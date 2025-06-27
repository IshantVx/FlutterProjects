import 'dart:convert';
import 'package:http/http.dart' as http;

class IHttpHelper {
  static const String _baseUrl = 'http://api-base-url.com';

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  /// ✅ Add this method to handle HTTP responses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode}\n${response.body}');
    }
  }
}
