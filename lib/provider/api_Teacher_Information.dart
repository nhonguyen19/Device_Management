import 'dart:convert';
import 'api_link.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:http/http.dart' as http;

class TeacherInformationProvider {

  static List<TeacherInformationObject> parseTeacherInformation(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TeacherInformationObject>((e) => TeacherInformationObject.fromJson(e)).toList();
}



static Future<List<TeacherInformationObject>> fetchTeacherInformation(http.Client http) async {
  String url= Ngrok().api_Teacher_Information;
  final response =  await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return parseTeacherInformation(response.body);
  } else {
    throw Exception('Failed to load');
  }
}
}
