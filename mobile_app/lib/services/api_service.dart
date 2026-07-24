import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Automatically select host based on platform:
  // Web / Windows / Desktop -> http://localhost/finalproject/api
  // Android Emulator -> http://10.0.2.2/finalproject/api
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://10.44.18.240/finalproject/api'; // Local IP for phone access
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/finalproject/api';
    } else {
      return 'http://10.44.18.240/finalproject/api';
    }
  }

  /// Helper to send POST requests with JSON payload or Form data
  static Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'Server error (${response.statusCode}): ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection error: Could not reach backend server ($baseUrl/$endpoint). Make sure XAMPP Apache is running.'
      };
    }
  }

  /// Helper to send GET requests
  static Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'Server error (${response.statusCode}): ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection error: Could not reach backend server ($baseUrl/$endpoint). Make sure XAMPP Apache is running.'
      };
    }
  }

  // 1. User Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await _post('login.php', {
      'email': email,
      'password': password,
    });
  }

  // 2. User Registration
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _post('register.php', {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    });
  }

  // 3. Create Pickup Request
  static Future<Map<String, dynamic>> createRequest({
    required String name,
    required String address,
    required String phone,
    required String wasteType,
    required String pickupDate,
  }) async {
    return await _post('request.php', {
      'name': name,
      'address': address,
      'phone': phone,
      'waste_type': wasteType,
      'pickup_date': pickupDate,
    });
  }

  // 4. Submit Complaint
  static Future<Map<String, dynamic>> submitComplaint({
    required String name,
    required String phone,
    required String type,
    required String message,
  }) async {
    return await _post('complaint.php', {
      'name': name,
      'phone': phone,
      'type': type,
      'message': message,
    });
  }

  // 5. Submit Feedback
  static Future<Map<String, dynamic>> submitFeedback({
    required String name,
    required int rating,
    required String drawbackOption,
    required String drawbackText,
  }) async {
    return await _post('feedback.php', {
      'name': name,
      'rating': rating,
      'drawback_option': drawbackOption,
      'drawback_text': drawbackText,
    });
  }

  // 6. Live Request Tracking
  static Future<Map<String, dynamic>> trackRequest(String trackingId) async {
    return await _post('tracking.php', {
      'tracking_id': trackingId,
    });
  }

  // 7. Admin Login
  static Future<Map<String, dynamic>> adminLogin(String email, String adminId) async {
    return await _post('admin_login.php', {
      'email': email,
      'admin_id': adminId,
    });
  }

  // 8. Fetch Admin Dashboard Data (Requests, Complaints, Feedback, Users)
  static Future<Map<String, dynamic>> getAdminData() async {
    return await _get('admin_data.php');
  }

  // 9. Execute Admin Action (Assign, Complete, Delete)
  static Future<Map<String, dynamic>> performAdminAction(String action, int id) async {
    return await _post('admin_action.php', {
      'action': action,
      'id': id,
    });
  }

  // 10. Forgot Password – Step 1: verify email exists
  static Future<Map<String, dynamic>> forgotPasswordVerify(String email) async {
    return await _post('forgot_password.php', {
      'action': 'verify_email',
      'email': email,
    });
  }

  // 11. Forgot Password – Step 2: reset password
  static Future<Map<String, dynamic>> forgotPasswordReset({
    required String email,
    required String newPassword,
  }) async {
    return await _post('forgot_password.php', {
      'action': 'reset_password',
      'email': email,
      'new_password': newPassword,
    });
  }
}
