import 'dart:convert';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_link.dart';
import 'package:http/http.dart' as http;

class TypeOfDeviceProvider {

  static List<TypeOfDiviceObject> parseTypeOfDevice(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TypeOfDiviceObject>((e) => TypeOfDiviceObject.fromJson(e)).toList();
}

static Future<List<TypeOfDiviceObject>> fetchTypeOfDivice(http.Client http) async {
 Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Type_Of_Devices));

  if (response.statusCode == 200) {
    return parseTypeOfDevice(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

static List<TypeOfDiviceObject> parseATypeOfDevice(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TypeOfDiviceObject>((e) => TypeOfDiviceObject.fromJson(e)).toList();
}




}
