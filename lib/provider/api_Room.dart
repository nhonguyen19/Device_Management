import 'dart:convert';
import 'package:devide_manager/provider/api_link.dart';
import 'package:http/http.dart' as http;

import '../object/RoomObject.dart';

class RoomProvider {

  static List<RoomObject> parseRoom(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<RoomObject>((e) => RoomObject.fromJson(e)).toList();
}

static Future<List<RoomObject>> fetchRoom(http.Client http) async {
 Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Rooms));

  if (response.statusCode == 200) {
    return parseRoom(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
