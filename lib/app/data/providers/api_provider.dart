import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/constants.dart';
import '../../routes/app_pages.dart';

const _kTimeout         = Duration(seconds: 15);
const _kAnalysisTimeout = Duration(seconds: 90);

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiProvider {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  static Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (withAuth) {
      final token = await _getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Map<String, dynamic> _handleResponse(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    final msg = body['message'] ??
        (body['errors'] != null
            ? (body['errors'] as Map).values.first.toString()
            : 'Terjadi kesalahan.');
    throw ApiException(msg.toString(), statusCode: res.statusCode);
  }

  // Wraps _handleResponse with 401 interception — clears session and redirects to login
  static Future<Map<String, dynamic>> _handleResponseWithAuth(http.Response res) async {
    if (res.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      await prefs.remove(AppConstants.userKey);
      Get.offAllNamed(Routes.LOGIN);
      throw ApiException('Sesi telah berakhir. Silakan masuk kembali.', statusCode: 401);
    }
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final res = await http
        .get(Uri.parse('${AppConstants.baseUrl}$path'), headers: await _headers())
        .timeout(_kTimeout);
    return _handleResponseWithAuth(res);
  }

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool withAuth = true,
    Duration timeout = _kTimeout,
  }) async {
    final res = await http
        .post(
          Uri.parse('${AppConstants.baseUrl}$path'),
          headers: await _headers(withAuth: withAuth),
          body: jsonEncode(body),
        )
        .timeout(timeout);
    return _handleResponseWithAuth(res);
  }

  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http
        .put(
          Uri.parse('${AppConstants.baseUrl}$path'),
          headers: await _headers(),
          body: jsonEncode(body),
        )
        .timeout(_kTimeout);
    return _handleResponseWithAuth(res);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final res = await http
        .delete(Uri.parse('${AppConstants.baseUrl}$path'), headers: await _headers())
        .timeout(_kTimeout);
    return _handleResponseWithAuth(res);
  }

  static Future<Map<String, dynamic>> postMultipart(
    String path,
    Map<String, String> fields,
    File imageFile,
  ) async {
    final token = await _getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}$path'),
    );
    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final streamed = await request.send().timeout(_kAnalysisTimeout);
    final res = await http.Response.fromStream(streamed);
    return _handleResponseWithAuth(res);
  }
}
