import 'package:devide_manager/provider/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:http/http.dart' as http;

import 'Home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<TeacherInformationObject>? listAccount;
  TeacherInformationObject? acc;
  bool isLoggedIn = false;

  Future<TeacherInformationObject?> performLogin() async {
    listAccount =
        await TeacherInformationProvider.fetchTeacherInformation(http.Client());
    for (var acc in listAccount!) {
      if (acc.userName == _emailController.text &&
          acc.password == _passwordController.text) {
        return acc;
      }
    }
    return null;
  }

  Future<void> saveLoggedInStatus() async {
    await Preferences.saveLoggedInStatus(true);
    await Preferences.saveCredentials(
        _emailController.text, _passwordController.text);
  }

  Future<void> checkLoggedInStatus() async {
    bool isLoggedIn = await Preferences.getLoggedInStatus();

    if (isLoggedIn) {
      Map<String, String> credentials = await Preferences.getCredentials();
      String savedEmail = credentials['email'] ?? '';
      String savedPassword = credentials['password'] ?? '';

      if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        acc = await performLogin();
        if (acc != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(teacherInformation: acc!),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage('assets/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                              .hasMatch(value)) {
                            return 'Vui lòng nhập email hợp lệ';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114)),
                          prefixIcon:
                              const Icon(Icons.email, color: Color(0xFF1F3C72)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114)),
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFF1F3C72)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF1F3C72),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              acc = await performLogin();
                              if (acc != null) {
                                await Preferences.saveLoggedInStatus(true);
                                await Preferences.saveCredentials(
                                    _emailController.text,
                                    _passwordController.text);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(teacherInformation: acc!),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đăng nhập thành công'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đăng nhập không thành công'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFF1F3C72),
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
