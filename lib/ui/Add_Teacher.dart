import 'dart:io';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _teacherNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  List<FacultyObject> listFaculty = [];
  int selectedFacultyID = 1;
  bool isRefresh = false;
  List<FacultyObject> _faculty = [];
  List<FacultyObject> _facultyDisplay = [];
  String selectedGender = 'Nam';

  List<Map<String, dynamic>> statusOptions = [
    {'value': 0, 'label': 'Admin'},
    {'value': 1, 'label': 'Giáo viên'},
  ];

  int selectedStatus = 1;

  Future<void> _fetchFaculties() async {
    try {
      listFaculty = await FacultyProvider.fetchFaculty(http.Client());
      setState(() {
        _faculty = listFaculty;
        _facultyDisplay = listFaculty;
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

  Future<void> _addTeacher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    int facultyID = selectedFacultyID;
    String email = _emailController.text;
    String password = _passwordController.text;
    String teachername = _teacherNameController.text;
    String phone = _phoneNumberController.text;
    String address = _addressController.text;
    String birthday = _dateOfBirthController.text;
    String imagePath = _image != null ? _image!.path : '';
    int status = selectedStatus;

    try {
      bool isSuccess = await TeacherInformationProvider.addTeacher(
          facultyID,
          imagePath,
          email,
          password,
          teachername,
          phone,
          address,
          selectedGender,
          birthday,
          status);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm giáo viên thành công'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm giáo viên thất bại'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm. Vui lòng thử lại sau!!'),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  //tải ảnh từ thư viện
  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh',
          style: TextStyle(
            color: Color.fromARGB(255, 31, 60, 114),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color.fromARGB(255, 31, 60, 114),
              image: _image != null
                  ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _image == null
                ? Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 48,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchFaculties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        title: Text('Thêm giáo viên'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildImagePreview(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _teacherNameController,
                          decoration: InputDecoration(
                            labelText: 'Họ và tên',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _phoneNumberController,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Số điện thoại',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
                            }
                            return null;
                          },
                        ),
                        //SizedBox(height: 16.0),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Địa chỉ',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập địa chỉ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Giới tính',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          value: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Nam',
                              child: Text('Nam'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Nữ',
                              child: Text('Nữ'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateOfBirthController,
                          decoration: InputDecoration(
                            labelText: 'Ngày sinh',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              locale: LocaleType.vi,
                              minTime: DateTime(1, 1, 1900),
                              maxTime: DateTime.now(),
                              onChanged: (date) {},
                              onConfirm: (date) {
                                setState(() {
                                  _dateOfBirthController.text =
                                      DateFormat('yyyy-MM-dd').format(date);
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng chọn ngày sinh';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Khoa',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          value: selectedFacultyID,
                          items: _facultyDisplay.map((FacultyObject faculty) {
                            return DropdownMenuItem<int>(
                              value: faculty.facultyID,
                              child: Text(faculty.facultyName.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedFacultyID = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn khoa';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Vai trò',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
                          value: selectedStatus,
                          items: statusOptions.map((option) {
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              child: Text(option['label']),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedStatus = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn vai trò';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                          ),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 31, 60, 114),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(145, 40),
                            primary: Color.fromARGB(255, 31, 60, 114),
                            onPrimary: Colors.white,
                          ),
                          onPressed: _isLoading ? null : _addTeacher,
                          child: _isLoading
                              ? SpinKitCircle(
                                  color: Colors.white,
                                  size: 24.0,
                                )
                              : Text(
                                  'Thêm ',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
