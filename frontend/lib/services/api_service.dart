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

  /// Fetches milestone alerts for a student (see notifications.js /
  /// disbursementService.js on the backend).
  static Future<List<dynamic>> getNotifications(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$studentId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode} ${response.body}');
    }
  }

  /// Fires a mock milestone notification (sanctioned / disbursed /
  /// action_required). Used by the dashboard to simulate a push alert the
  /// moment an application reaches one of those stages.
   /// Fires a mock milestone notification (sanctioned / disbursed /
  /// action_required). Used by the dashboard to simulate a push alert the
  /// moment an application reaches one of those stages.
  static Future<Map<String, dynamic>> triggerNotification({
    required String studentId,
    required String applicationId,
    required String milestone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notifications/trigger'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId,
        'applicationId': applicationId,
        'milestone': milestone,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to trigger notification: ${response.statusCode} ${response.body}');
    }
  }

    /// Checks whether a student is eligible to start a new scheme application.
  /// Enforces the "one scheme at a time" rule from the problem statement.
  static Future<Map<String, dynamic>> checkEligibility(String studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/eligibility/$studentId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check eligibility: ${response.statusCode} ${response.body}');
    }
  }

  /// Ministry-facing: fetches ST students enrolled per UDISE+/APAAR/OTR
  /// but not availing any scholarship across NSP, SFMP, or NOS.
  static Future<Map<String, dynamic>> getCoverageGap() async {
    final response = await http.get(
      Uri.parse('$baseUrl/coverage-gap'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load coverage gap data: ${response.statusCode} ${response.body}');
    }
  }
}