import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.x.x:5000'; // استبدل بعنوان الخادم الصحيح

  // تسجيل مستخدم جديد مع بيانات إضافية
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String age,
    String phone,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'first_name': firstName,
              'last_name': lastName,
              'age': age,
              'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 10)); // ضبط وقت الانتظار

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // تسجيل الدخول مع دور المستخدم
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      final result = _handleResponse(response);
      if (result['success']) {
        result['role'] = result['data']['role'] ?? 'client'; // إضافة الدور
      }
      return result;
    } catch (e) {
      return _handleError(e);
    }
  }

  // استعادة كلمة المرور (إرسال كود)
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // تغيير كلمة المرور
  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'code': code,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // معالجة استجابات الخادم
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      try {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Unknown error',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Error: ${response.statusCode}, Response: ${response.body}',
        };
      }
    }
  }

  // معالجة الأخطاء العامة
  static Map<String, dynamic> _handleError(dynamic error) {
    if (error is SocketException) {
      return {'success': false, 'message': 'No Internet connection'};
    } else if (error is TimeoutException) {
      return {'success': false, 'message': 'Connection timed out'};
    } else {
      return {'success': false, 'message': 'An unexpected error occurred: $error'};
    }
  }
}
