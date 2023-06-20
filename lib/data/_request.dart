import 'package:http/http.dart' as http;
import 'dart:convert';

Future request(Map<String, String> body) async {
  try {
    const String url = "http://192.168.12.1/goat/";
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode != 200) {
      return [
        {"m": "Failed to connect"}
      ];
    }
    return json.decode(response.body);
  } catch (e) {
    return [
      {"m": e.toString()}
    ];
  }
}
