import 'dart:async';

import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/provider/share_preferences.dart';
import 'package:devide_manager/ui/Add_Teacher.dart';
import 'package:devide_manager/ui/UserDetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  List<TeacherInformationObject> listUser;
  User({Key? key, required this.listUser});

  @override
  _UserState createState() => _UserState(listUser: listUser) ;
}

class _UserState extends State<User> {
  List<TeacherInformationObject> listUser = [];
  bool _isSearching = false;
  List<TeacherInformationObject> _user = [];
  StreamController<List<TeacherInformationObject>> _userStreamController =
      StreamController<List<TeacherInformationObject>>();

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
      _userStreamController.add(listUser);
    } catch (error) {
      print('Lỗi: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi, Vui lòng thử lại sau'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar(),
      body: StreamBuilder<List<TeacherInformationObject>>(
        stream: _userStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _user = snapshot.data!;
            return RefreshIndicator(
              onRefresh: fetchUsers,
              child: _buildUserList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi, Vui lòng thử lại sau'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
        },
      ),
    );
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
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _user = listUser.where((listUser) {
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
    if (_user.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
      itemCount: _user.length,
      itemBuilder: (context, index) => _buildUserItem(index),
    );
  }

  Widget _buildUserItem(int index) {
    TeacherInformationObject teacher = _user[index];
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetail(
                      user: _user[index],
                    ),
                  ),
                );
              },
              onLongPress: () {
                _showDeleteConfirmationDialog(teacher, context)
                    .then((shouldReload) {
                  if (shouldReload == true) {
                    fetchUsers();
                  }
                });
              },
              child: ListTile(
                leading: Container(
                  width: screenHeight / 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _user[index].image.toString(),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: Text(_user[index].teacher_Name.toString()),
                subtitle: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetail(
                          user: _user[index],
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
                ),
                trailing: Image.asset(
                  (() {
                    if (_user[index].status == 1) {
                      return 'assets/Gif_Status/user-connect.gif';
                    } else if (_user[index].status == 2) {
                      return 'assets/Gif_Status/teacher.gif';
                    } else if (_user[index].status == 0) {
                      return 'assets/Gif_Status/retired.gif';
                    } else {
                      return 'assets/Gif_Status/default.gif';
                    }
                  })(),
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
      TeacherInformationObject teacher, BuildContext context) async {
    TeacherInformationObject? currentUser = await Preferences.getCurrentUser();
    bool isAdmin = teacher.status == 1;
    String name= teacher.teacher_Name.toString();
   
       if (currentUser?.status == 1 &&
        currentUser != null &&
        currentUser.userName != teacher.userName) {
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
              'Bạn có chắc chắn muốn xóa giáo viên $name?',
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
                  TeacherInformationProvider.updateStatus(teacher.id!, 0);
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Không thể xóa giáo viên',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 31, 60, 114),
            content: Text(
              'Bạn không có quyền xóa giáo viên này.Do tài khoản đang được sử dụng, hoặc bạn không phải là Admin ((:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Đóng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
