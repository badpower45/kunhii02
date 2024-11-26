import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProductsService {
  static const String baseUrl = 'http://192.168.x.x:5000'; // عنوان الخادم

  // جلب قائمة المنتجات
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // إضافة منتج جديد
  static Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/products'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(product),
          )
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // تحديث منتج
  static Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> product) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(product),
          )
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // حذف منتج
  static Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
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
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      try {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      } catch (e) {
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
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
      return {'success': false, 'message': 'Unexpected error: $error'};
    }
  }
}
