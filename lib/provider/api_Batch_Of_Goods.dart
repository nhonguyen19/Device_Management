import 'dart:convert';
import 'package:devide_manager/object/BatchOfGoodObject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_link.dart';

class BatchOfGoodProvide {

  static List<BatchOfGoodObject> parseBatchOfGood(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BatchOfGoodObject>((e) => BatchOfGoodObject.fromJson(e)).toList();
}

static Future<List<BatchOfGoodObject>> fetchBatchOfGood(http.Client http) async {
    Ngrok ngrok= Ngrok();
  final response =  await http.get(Uri.parse(ngrok.api_Batch_Of_Goods));

  if (response.statusCode == 200) {
    return parseBatchOfGood(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

}
