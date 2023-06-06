import 'dart:convert';
import 'api_link.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:http/http.dart' as http;

class ConfigurationSpecificationProvide {

  static List<ConfigurationSpecificationObject> parseConfigurationSpecification(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ConfigurationSpecificationObject>((e) => ConfigurationSpecificationObject.fromJson(e)).toList();
}

static Future<List<ConfigurationSpecificationObject>> fetchConfigurationSpecification(http.Client http) async {
 String url= Ngrok().api_Configuration_Specification;
  final response =  await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return parseConfigurationSpecification(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
