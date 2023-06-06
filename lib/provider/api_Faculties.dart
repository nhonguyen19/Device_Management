import 'dart:convert';
import 'dart:io';
import 'package:devide_manager/provider/api_link.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../object/FacultyOject.dart';

class FacultyProvider {
  static List<FacultyObject> parseFaculty(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FacultyObject>((e) => FacultyObject.fromJson(e)).toList();
  }

  //lấy danh sách khoa
  static Future<List<FacultyObject>> fetchFaculty(
      http.Client httpClient) async {
    Ngrok ngrok = Ngrok();
    final response = await httpClient.get(Uri.parse(ngrok.api_Faculties));

    if (response.statusCode == 200) {
      return parseFaculty(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

//Thêm hình ảnh vào API
  static Future<bool> addFaculty(
      String name, String imagePath, int status) async {
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
      final url = Uri.parse(ngrok.api_Faculties);
      final response = await http.post(
        url,
        body: {
          'Faculty_Name': name,
          'Image': imageUrl,
          'Status': status.toString(),
        },
      );

      if (response.statusCode == 201) {
        return true; // Faculty added successfully
      } else {
        return false; // Failed to add faculty
      }
    } catch (error) {
      print('Error adding faculty: $error');
      throw Exception('Failed to add faculty: $error');
    }
  }

//cập nhật khoa
  static Future<bool> updateFaculty(
      {required int facultyID,
      String? name,
      String? imagePath,
      int? status}) async {
    try {
      Ngrok ngrok = Ngrok();
      final url = Uri.parse('${ngrok.api_Faculties}/$facultyID');
      Map<String, dynamic> body = {};

      if (name != null) {
        body['Faculty_Name'] = name;
      }

      if (imagePath != null) {
        File imageFile = File(imagePath);

        if (!imageFile.existsSync()) {
          throw Exception('Image file does not exist');
        }

        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref();
        final String fileName = path.basename(imageFile.path);

        // Tải hình ảnh mới lên Firebase Storage
        await storageRef.child(fileName).putFile(imageFile);

        // Lấy URL của hình ảnh mới từ Firebase Storage
        final imageUrl = await storageRef.child(fileName).getDownloadURL();

        body['Image'] = imageUrl;
      }

      if (status != null) {
        body['Status'] = status.toString();
      }

      final response = await http.put(url, body: body);

      if (response.statusCode == 200) {
        return true; // Faculty updated successfully
      } else {
        return false; // Failed to update faculty
      }
    } catch (error) {
      print('Error updating faculty: $error');
      throw Exception('Failed to update faculty: $error');
    }
  }

// xóa khoa
  static Future<bool> deleteFaculty(int facultyID) async {
    try {
      Ngrok ngrok = Ngrok();
      final url = Uri.parse('${ngrok.api_Faculties}/$facultyID');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true; // Faculty deleted successfully
      } else {
        return false; // Failed to delete faculty
      }
    } catch (error) {
      print('Error deleting faculty: $error');
      throw Exception('Failed to delete faculty: $error');
    }
  }

//cập nhật trạng thái
  static Future<bool> updateStatus(int facultyID, int status) async {
    try {
      Ngrok ngrok = Ngrok();
      final url = Uri.parse('${ngrok.api_Faculties}/$facultyID');

      final response = await http.patch(
        url,
        body: {'Status': status.toString()},
      );

      if (response.statusCode == 200) {
        return true; // Status updated successfully
      } else {
        return false; // Failed to update status
      }
    } catch (error) {
      print('Error updating status: $error');
      throw Exception('Failed to update status: $error');
    }
  }
}
