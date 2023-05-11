import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiUrl = "https://localhost/goat/";

Future request(data) {
  return http.post(Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data)).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw const HttpException("Failed to connect");
      }

      return jsonDecode(response.body);
    });
}


