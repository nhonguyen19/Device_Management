import 'dart:convert';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_link.dart';

class BrandProvide {

  static List<BrandObject> parseBrand(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BrandObject>((e) => BrandObject.fromJson(e)).toList();
}

static Future<List<BrandObject>> fetchBrand(http.Client http) async {
    Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Brands));

  if (response.statusCode == 200) {
    return parseBrand(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
