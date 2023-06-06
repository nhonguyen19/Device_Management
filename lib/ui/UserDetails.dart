import 'package:devide_manager/widget/widget.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:http/http.dart' as http;

class UserDetail extends StatefulWidget {
  TeacherInformationObject user;
  UserDetail({Key? key, required this.user});

  @override
  _UserDetailState createState() => _UserDetailState(user: user);
}

class _UserDetailState extends State<UserDetail> {
  TeacherInformationObject user;
  _UserDetailState({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin giáo viên'),
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
      ),
      backgroundColor: Color.fromARGB(255, 31, 60, 114),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/Gif_Status/Background_Avatar.gif"),
              fit: BoxFit.cover,
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 3,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CircleAvatar(
                      maxRadius: 50,
                      minRadius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(user.image.toString()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
         Container(
          color: Colors.white,
          child:  Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Icon(Icons.info)
              ),
              Padding(padding: EdgeInsets.all(2)),
              Container(
                child: Text('Thông tin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
                ),
              ),
            ],
          ),
          ),
         ),

         //Hiển thị tên của giáo viên
                    Container(
                      child: ListTile(
                            leading: Padding(padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.person,color: Colors.white),
                          ), 
                          title: Text(
                            'Họ tên',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle:
                          Text(user.teacher_Name!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        ),
                    ),

         //Hiển thị Email của giáo viên (Tài khoản của giáo viên)
                    Container(
                      child: ListTile(
                            leading: Padding(padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.email_outlined,color: Colors.white,)
                          ), 
                          title: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle:
                          Text(user.userName!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        ),
                    ),

         //Hiển thị Khoa của giáo viên
                    Container(
                      child: ListTile(
                            leading: Padding(padding: EdgeInsets.only(top: 8),
                          child: Image.asset('assets/Icon/faculty_white.png',
                          height: 28,
                          width: 28),
                          ), 
                          title: Text(
                            'Khoa',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle:GetFaculty(id:user.faculty_ID!,displayColor:Colors.white)
                        ),
                    ),

            //Hiển thị số điện thoại của giáo viên
                    Container(
                      child: ListTile(
                            leading: Padding(padding: EdgeInsets.only(top: 7),
                          child: Icon(Icons.phone_enabled_outlined,color:Colors.white)
                          ), 
                          title: Text(
                            'SĐT',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle:
                          Text(user.phone_Number!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        ),
                    ),

          //Hiển thị địa chỉ của giáo viên
                    Container(
                      child: ListTile(
                          leading: Padding(padding: EdgeInsets.only(top: 0),
                          child: Image.asset('assets/Icon/address.png',
                          height: 28,
                          width: 28),
                          ), 
                          title: Text(
                            'Địa chỉ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle:Text(user.address!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        ),
                    )

            ],
          ), 
              )
           );
  }
}
