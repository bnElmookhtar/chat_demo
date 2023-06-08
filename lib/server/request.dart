import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future request(BuildContext context, Map<String, String> body) async {
  try {
    // final response = await http.post(Uri.parse("http://localhost/goat/"), body: body); // used to debug 
    final response = await http.post(Uri.parse("http://192.168.12.1/goat/"), body: body); // used in release
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
