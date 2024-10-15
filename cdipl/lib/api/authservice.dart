import 'dart:convert';
import 'package:cdipl/constants.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${serverurl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'employeeId': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
