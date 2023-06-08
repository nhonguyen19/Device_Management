import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devide_manager/provider/api_Faculties.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({Key? key}) : super(key: key);

  @override
  _AddFacultyScreenState createState() => _AddFacultyScreenState();
}

class _AddFacultyScreenState extends State<AddFacultyScreen> {
  TextEditingController _nameController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  List<Map<String, dynamic>> statusOptions = [
    {'value': 1, 'label': 'Hoạt động'},
    {'value': 0, 'label': 'Không hoạt động'},
  ];
  int selectedStatus = 1;

  Future<void> _addFaculty() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text;
    String imagePath = _image != null ? _image!.path : '';
    int status = selectedStatus;

    try {
      bool isSuccess =
          await FacultyProvider.addFaculty(name, imagePath, status);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm khoa thành công'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm khoa thất bại'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm. Vui lòng thử lại sau!!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        title: Text(
          'Thêm khoa',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
                onPressed: _isLoading ? null : _addFaculty,
                child: _isLoading
                    ? SpinKitCircle(
                        color: Colors.white,
                        size: 24.0,
                      )
                    : Text(
                        'Thêm',
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
