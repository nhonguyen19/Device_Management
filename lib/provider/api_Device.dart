import 'dart:convert';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/provider/api_link.dart';
import 'package:http/http.dart' as http;

class DeviceProvider {

  static List<DeviceObject> parseDevice(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DeviceObject>((e) => DeviceObject.fromJson(e)).toList();
}

static Future<List<DeviceObject>> fetchDevice(http.Client http) async {
  Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Devices));

  if (response.statusCode == 200) {
    return parseDevice(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
