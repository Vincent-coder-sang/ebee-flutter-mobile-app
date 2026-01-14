// app/data/providers/api_provider.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';
import 'local_storage.dart';

class ApiProvider extends GetxService {
  static const String baseUrl = ApiEndpoints.baseUrl;

  Future<ApiProvider> init() async {
    await LocalStorage.init();
    return this;
  }

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> _authHeaders() {
    final token = LocalStorage.getToken();
    return token != null
        ? {..._headers(), 'Authorization': 'Bearer $token'}
        : _headers();
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _authHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _authHeaders(),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _authHeaders(),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _authHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic data;

    try {
      data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      data = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    if (response.statusCode == 401) {
      LocalStorage.clearAuthData();
      throw 'Session expired. Please login again.';
    }

    throw data?['message'] ?? 'Request failed (${response.statusCode})';
  }
}
