import 'dart:convert';

import 'package:http/http.dart' as http;

getContact() async {
  var response = await http.get(
    Uri.parse(
      "https://dummyjson.com/users"
    )
  );

  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body)['users'];
    default:
      return [];
  }
}