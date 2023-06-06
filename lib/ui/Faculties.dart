import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/ui/Add_Faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'Edit_Faculty.dart';

class Don_Vi extends StatefulWidget {
  const Don_Vi({Key? key});

  @override
  _Don_ViState createState() => _Don_ViState();
}

class _Don_ViState extends State<Don_Vi> {
  bool _isSearching = false;
  List<FacultyObject> _faculty = [];
  List<FacultyObject> _facultyDisplay = [];
  String? _image;

  @override
  void initState() {
    super.initState();
    fetchFaculties();
  }

  Future<void> fetchFaculties() async {
    try {
      List<FacultyObject> faculties =
          await FacultyProvider.fetchFaculty(http.Client());
      setState(() {
        _faculty = faculties;
        _facultyDisplay = faculties;
      });
    } catch (error) {
      print('Lỗi kết nối api: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi. Vui lòng thử lại sau!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar(),
      body: _buildFacultyList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToFacultyAddScreen().then((shouldReload) {
            if (shouldReload == true) {
              fetchFaculties(); // Reload faculties after adding a new faculty
            }
          });
        },
      ),
    );
  }

  AppBar _searchBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 31, 60, 114),
      title: _isSearching
          ? TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _facultyDisplay = _faculty.where((faculty) {
                    String statusString = faculty.status == 1
                        ? 'Đang hoạt động'
                        : 'Ngưng hoạt động';
                    return faculty.facultyName!.toLowerCase().contains(text) ||
                        faculty.image!.toLowerCase().contains(text) ||
                        statusString.toLowerCase().contains(text);
                  }).toList();
                });
              },
            )
          : Text('Danh sách đơn vị'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFacultyList() {
    if (_facultyDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }

    return ListView.builder(
      itemCount: _facultyDisplay.length,
      itemBuilder: (context, index) => _buildFacultyItem(index),
    );
  }

  Widget _buildFacultyItem(int index) {
    final FacultyObject faculty = _facultyDisplay[index];
    bool isActive = (faculty.status == 1);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(faculty.image.toString()),
        ),
        title: Text(
          faculty.facultyName.toString(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          isActive ? 'Đang hoạt động' : 'Ngưng hoạt động',
          style: TextStyle(
            color: isActive ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.orangeAccent),
          onPressed: () {
            _navigateToFacultyEditScreen(faculty).then((shouldReload) {
              if (shouldReload == true) {
                fetchFaculties(); // Reload faculties after editing a faculty
              }
            });
          },
        ),
        onLongPress: () {
          _showDeleteConfirmationDialog(faculty).then((shouldReload) {
            if (shouldReload == true) {
              fetchFaculties(); // Load lại trạng thái sau khi xóa khoa
            }
          });
        },
      ),
    );
  }

  Future<bool?> _navigateToFacultyAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFacultyScreen(),
      ),
    );

    if (result == true) {
      return true;
    }
    return false;
  }

  Future<bool?> _navigateToFacultyEditScreen(FacultyObject faculty) async {
    // print("link ảnh: " + faculty.image.toString());
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditFacultyScreen(faculty: faculty, image: faculty.image!),
      ),
    );

    if (result == true) {
      return true;
    }
    return false;
  }






  Future<bool?> _showDeleteConfirmationDialog(FacultyObject faculty) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa khoa'),
          content: Text('Bạn có chắc chắn muốn xóa khoa này?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () async {
                 FacultyProvider.updateStatus(faculty.facultyID!,0);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
