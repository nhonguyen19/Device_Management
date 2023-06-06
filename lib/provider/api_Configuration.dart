import 'dart:convert';
import 'api_link.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:http/http.dart' as http;

class ConfigurationProvide {

  static List<ConfigurationObject> parseConfiguration(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ConfigurationObject>((e) => ConfigurationObject.fromJson(e)).toList();
}

static Future<List<ConfigurationObject>> fetchConfiguration(http.Client http) async {
 String url= Ngrok().api_Configuration;
  final response =  await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return parseConfiguration(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
