import 'dart:convert';
import 'package:devide_manager/provider/api_link.dart';
import 'package:http/http.dart' as http;

import '../object/SupplierObject.dart';

class SupplierProvider {

  static List<SupplierObject> parseSupplier(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SupplierObject>((e) => SupplierObject.fromJson(e)).toList();
}

static Future<List<SupplierObject>> fetchSupplier(http.Client http) async {
 Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Suppliers));

  if (response.statusCode == 200) {
    return parseSupplier(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
