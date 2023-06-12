import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/ui/Add_Teacher.dart';
import 'package:devide_manager/ui/DeviceDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/UserDetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  List<TeacherInformationObject> listUser;
  User({Key? key, required this.listUser});

  @override
  _UserState createState() => _UserState(listUser: listUser);
}

class _UserState extends State<User> {
  List<TeacherInformationObject> listUser = [];
  bool _isSearching = false;
  List<TeacherInformationObject> _user = [];
  List<TeacherInformationObject> _userDisplay = [];
  _UserState({Key? key, required this.listUser});
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      if (!isRefresh) {
        listUser = listUser;
        isRefresh = true;
      } else {
        listUser = await TeacherInformationProvider.fetchTeacherInformation(
            http.Client());
      }
      setState(() {
        _user = listUser;
        _userDisplay = listUser;
      });
    } catch (error) {
      print('Lỗi: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi, Vui lòng thử lại sau'),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _searchBar(),
        body: RefreshIndicator(
          onRefresh: fetchUsers,
          child: _buildUserList(),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 31, 60, 114),
            child: Icon(Icons.add),
            onPressed: () {
              _navigateToTeacherAddScreen().then((shouldReload) {
                if (shouldReload == true) {
                  fetchUsers();
                }
              });
            }));
  }

  Future<bool?> _navigateToTeacherAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTeacher(),
      ),
    );

    if (result == true) {
      return true;
    }
    return false;
  }

  AppBar _searchBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 31, 60, 114),
      title: _isSearching
          ? TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true, // Tự động focus vào TextField khi hiển thị
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _userDisplay = _user.where((listUser) {
                    return listUser.userName!.toLowerCase().contains(text) ||
                        listUser.teacher_Name!.toLowerCase().contains(text) ||
                        listUser.address!.toLowerCase().contains(text) ||
                        listUser.phone_Number!.toLowerCase().contains(text);
                  }).toList();
                });
              },
            )
          : const Text('Danh sách giáo viên'),
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

  Widget _buildUserList() {
    if (_userDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _userDisplay.length,
        itemBuilder: (context, index) => _buildUserItem(index));
  }

  Widget _buildUserItem(int index) {
    TeacherInformationObject teacher = _userDisplay[index];
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: screenHeight / 12,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Bo góc của khung ảnh
                  child: Image.network(
                    _userDisplay[index].image.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(_userDisplay[index].teacher_Name.toString()),
              subtitle: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetail(
                        user: _userDisplay[index],
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onLongPress: () {
                  _showDeleteConfirmationDialog(teacher).then((shouldReload) {
                    if (shouldReload == true) {
                      fetchUsers(); // Load lại trạng thái sau khi xóa giác viên
                    }
                  });
                },
              ),
              trailing: Image.asset(
                (() {
                  if (_userDisplay[index].status == 1) {
                    return 'assets/Gif_Status/user-connect.gif';
                  } else if (_userDisplay[index].status == 2) {
                    return 'assets/Gif_Status/teacher.gif';
                  } else {
                    return 'assets/Gif_Status/default.gif'; // Hình ảnh mặc định nếu không thỏa điều kiện
                  }
                })(),
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
      TeacherInformationObject teacher) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Xóa giáo viên',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 31, 60, 114),
          content: Text(
            'Bạn có chắc chắn muốn xóa giáo viên này?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                TeacherInformationProvider.deleteTeacher(teacher.id!);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
