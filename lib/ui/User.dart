import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/ui/DeviceDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/UserDetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  List<TeacherInformationObject> listUser;
  User({Key?key,required this.listUser});

  @override
  _UserState createState() => _UserState(listUser:listUser);
}

class _UserState extends State<User> {
  List<TeacherInformationObject> listUser = [];
  bool _isSearching = false;
  List<TeacherInformationObject> _user = [];
  List<TeacherInformationObject> _userDisplay = [];
  _UserState({Key?key,required this.listUser});
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
     listUser = listUser;
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
      body: _buildUserList(),
    );
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
              width: screenHeight/12, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Bo góc của khung ảnh
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
                    builder: (context) =>
                        UserDetail(user: _userDisplay[index],),
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
)
          ),
        ],
      ),
      )
    );
  }
}

