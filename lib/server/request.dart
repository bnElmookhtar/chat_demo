import 'package:http/http.dart' as http;
import 'dart:convert';

Future request(Map<String, String> body) async {
  try {
    final response = await http.post(Uri.parse("http://localhost/goat/"), body: body);
  if (response.statusCode != 200) {
      return null;
  } 
  return json.decode(response.body);
  } catch (e) {

    return null;
  }
}
