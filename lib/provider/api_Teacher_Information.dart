import 'dart:convert';
import 'dart:io';


import 'api_link.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class TeacherInformationProvider {
  static List<TeacherInformationObject> parseTeacherInformation(
      String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TeacherInformationObject>(
            (e) => TeacherInformationObject.fromJson(e))
        .toList();
  }

  //lấy danh sách giáo viên
  static Future<List<TeacherInformationObject>> fetchTeacherInformation(
      http.Client http) async {
    String url = Ngrok().api_Teacher_Information;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return parseTeacherInformation(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

//Thêm giáo viên
  static Future<bool> addTeacher(
    int facultyID,
    String imagePath,
    String email,
    String password,
    String teachername,
    String phone,
    String address,
    String gender,
    String birthday,
    int status,
  ) async {
    try {
      File imageFile = File(imagePath);

      if (!imageFile.existsSync()) {
        throw Exception('Image file does not exist');
      }

      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();
      final String fileName = path.basename(imageFile.path);

      // Tải hình ảnh lên Firebase Storage
      await storageRef.child(fileName).putFile(imageFile);

      // Lấy URL của hình ảnh từ Firebase Storage
      final imageUrl = await storageRef.child(fileName).getDownloadURL();

      Ngrok ngrok = Ngrok();
      final url = Uri.parse(ngrok.api_Teacher_Information);
      final response = await http.post(
        url,
        body: {
          'Faculty_ID': facultyID.toString(),
          'Image': imageUrl,
          'Username': email,
          'Password': password,
          'Teacher_Name': teachername,
          'Phone_Number': phone,
          'Address': address,
          'Gender': gender,
          'Date_Of_Birth': birthday,
          'Status': status.toString(),
        },
      );

      if (response.statusCode == 201) {
        return true; // Teacher added successfully
      } else {
        return false; // Failed to add Teacher
      }
    } catch (error) {
      print('Error adding teacher: $error');
      throw Exception('Failed to add teacher: $error');
    }
  }
}
