import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CheckoutService {
  static const String baseUrl = 'http://192.168.x.x:5000'; // استبدل بعنوان الخادم الصحيح

  // إرسال طلب التشيك آوت
  static Future<Map<String, dynamic>> checkout({
    required List<Map<String, dynamic>> cartItems,
    required double totalPrice,
    required String address,
    String? altAddress,
    required String phone,
    String? altPhone,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/checkout'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'cart_items': cartItems,
              'total_price': totalPrice,
              'address': address,
              'alt_address': altAddress,
              'phone': phone,
              'alt_phone': altPhone,
            }),
          )
          .timeout(const Duration(seconds: 10)); // ضبط وقت الانتظار

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
