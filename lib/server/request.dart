import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

Future request(BuildContext context, Map<String, String> body) async {
  try {
    // final String url = "http://localhost/goat/"; // used for debug
    final String url = "http://192.168.12.1/goat/"; // used with release
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode != 200) {
      throw Exception();
    } 
    var results = json.decode(response.body);
    // print(results);
    if ( results[0].keys.contains("error") ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(results[0]["error"])),
      );
      return null;
    }
    return results;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not connect\n' + e.toString())),
    );
    print(e.toString());
    return null;
  }
}
