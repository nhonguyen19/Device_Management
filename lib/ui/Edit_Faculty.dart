import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/object/FacultyOject.dart';

class EditFacultyScreen extends StatefulWidget {
  final FacultyObject faculty;
  final String image;

  const EditFacultyScreen({required this.faculty, required this.image});

  @override
  _EditFacultyScreenState createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  TextEditingController _nameController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  late FacultyObject facultyObject;

  List<Map<String, dynamic>> statusOptions = [
    {'value': 1, 'label': 'Hoạt động'},
    {'value': 0, 'label': 'Không hoạt động'},
  ];
  int selectedStatus = 1;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.faculty.facultyName!;
    selectedStatus = widget.faculty.status!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    String newName = _nameController.text;
    int newStatus = int.parse(selectedStatus.toString());
    String imagePath = _image != null ? _image!.path : '';

    try {
      bool isSuccess = await FacultyProvider.updateFaculty(
        facultyID: widget.faculty.facultyID!,
        name: newName,
        imagePath: imagePath,
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

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                : null,
          ),
          child: _image == null
              ? Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.white,
                )
              : null,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        title: Text(
          'Chỉnh sửa khoa',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImagePreview(),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên khoa',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Trạng thái',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedStatus,
                onChanged: (int? value) {
                  setState(() {
                    selectedStatus = value ?? 1;
                  });
                },
                items: statusOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(145, 50),
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
      ),
    );
  }
}
