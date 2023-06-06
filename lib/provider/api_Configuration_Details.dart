import 'dart:convert';
import 'api_link.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:http/http.dart' as http;

class ConfigurationDetailsProvide {

  static List<ConfigurationDetailsObject> parseConfigurationDetails(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ConfigurationDetailsObject>((e) => ConfigurationDetailsObject.fromJson(e)).toList();
}

static Future<List<ConfigurationDetailsObject>> fetchConfigurationDetails(http.Client http) async {
 String url= Ngrok().api_Configuration_Details;
  final response =  await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return parseConfigurationDetails(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
