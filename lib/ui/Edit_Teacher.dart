import 'dart:io';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditTeacher extends StatefulWidget {
  final TeacherInformationObject teacher;
  final String image;
  const EditTeacher({
    Key? key,
    required this.teacher,
    required this.image,
  }) : super(key: key);
  @override
  State<EditTeacher> createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _teacherNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  bool isChoose = false;
  List<FacultyObject> listFaculty = [];
  int selectedFacultyID = 1;
  bool isRefresh = false;
  List<FacultyObject> _faculty = [];
  List<FacultyObject> _facultyDisplay = [];
  String selectedGender = 'Nam';
  late String oldImage;
  List<Map<String, dynamic>> statusOptions = [
    {'value': 1, 'label': 'Admin'},
    {'value': 0, 'label': 'Nghỉ hưu'},
    {'value': 2, 'label': 'Giáo viên'},
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

  @override
  void initState() {
    super.initState();
    selectedFacultyID = widget.teacher.faculty_ID!;
    oldImage = widget.teacher.image!;
    _emailController.text = widget.teacher.userName!;
    _passwordController.text = widget.teacher.password!;
    _teacherNameController.text = widget.teacher.teacher_Name!;
    _phoneNumberController.text = widget.teacher.phone_Number!;
    _addressController.text = widget.teacher.address!;
    selectedGender = widget.teacher.gender!;
    _dateOfBirthController.text = widget.teacher.date_Of_Birth!;
    selectedStatus = widget.teacher.status!;
    _fetchFaculties();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _teacherNameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    int newFacultyID = int.parse(selectedFacultyID.toString());
    String imagePath = _image != null ? _image!.path : oldImage;
    String newUserName = _emailController.text;
    String newPassword = _passwordController.text;
    String newNameTeacher = _teacherNameController.text;
    String newPhone = _phoneNumberController.text;
    String newAddress = _addressController.text;
    String newGender = selectedGender.toString();
    String newDateOfBirth = _dateOfBirthController.text;
    int newStatus = int.parse(selectedStatus.toString());

    try {
      bool isSuccess = await TeacherInformationProvider.updateTeacher(
        id: widget.teacher.id!,
        facultyID: newFacultyID,
        imagePath: imagePath,
        isChoose: isChoose,
        email: newUserName,
        password: newPassword,
        teachername: newNameTeacher,
        phone: newPhone,
        address: newAddress,
        gender: newGender.toString(),
        birthday: newDateOfBirth,
        status: newStatus,
      );

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chỉnh sửa khoa thành công'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chỉnh sửa khoa thất bại'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chỉnh sửa. Vui lòng thử lại sau!!'),
        ),
      );
      print(error);
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
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromARGB(255, 31, 60, 114),
            image: _image != null
                ? DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: NetworkImage(oldImage!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(150, 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                backgroundColor: Color.fromARGB(255, 31, 60, 114)),
            onPressed: _pickImage,
            child: Text("Chỉnh sửa ảnh")),
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
      isChoose = true;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        title: Text('Chỉnh sửa thông tin'),
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
                          onPressed: _isLoading ? null : _saveChanges,
                          child: _isLoading
                              ? SpinKitCircle(
                                  color: Colors.white,
                                  size: 24.0,
                                )
                              : Text(
                                  'Lưu thay đổi',
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
