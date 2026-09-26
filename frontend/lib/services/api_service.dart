import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

// Central place for all calls to the Node/Express backend.
// IMPORTANT: 10.0.2.2 is the special address Android emulators use to reach
// "localhost" on your actual computer. If you're testing on Chrome/Windows
// instead of an Android emulator, change this to "localhost".
class ApiService {
  static String get baseUrl {
    if (kIsWeb) return "http://localhost:3000/api";
    if (Platform.isAndroid) return "http://10.0.2.2:3000/api";
    return "http://localhost:3000/api";
  }

  /// Logs in with a student ID. Returns the response body as a Map,
  /// or throws an Exception if the request fails.
  static Future<Map<String, dynamic>> login(String studentId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'studentId': studentId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.statusCode} ${response.body}');
    }
  }

  /// Fetches the unified dashboard for a student - merges NSP, SFMP, and
  /// NOS data into one normalized response (see aggregationService.js).
  static Future<Map<String, dynamic>> getDashboard(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/applications/$studentId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard: ${response.statusCode} ${response.body}');
    }
  }
}