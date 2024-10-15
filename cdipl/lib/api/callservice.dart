import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:cdipl/constants.dart';
import 'package:cdipl/helpers/tokenmanager.dart';
import 'package:http/http.dart' as http;

class CallApiService {
  Future<List<Map<String, dynamic>>> fetchColdData() async {
    String token = await TokenManager.getToken() ?? '';
    inspect('token: $token');
    try {
      final response = await http.get(
        Uri.parse('${serverurl}/getcoldcall/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token here
        },
      );
      print('jsonResponse: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['message'] == 'success' &&
            jsonResponse['calls'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['calls']);
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMyleadsData() async {
    String token = await TokenManager.getToken() ?? '';
    inspect('token: $token');
    try {
      final response = await http.get(
        Uri.parse('${serverurl}/get/myleads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token here
        },
      );
      print('jsonResponse: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['message'] == 'success' &&
            jsonResponse['leads'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['leads']);
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
