import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/constants.dart';

class AuthRepository {
  Future<ApiResponse<UserModel>> register(
      String name, String email, String password) async {
    try {
      final res = await ApiProvider.post(
        '/auth/register',
        {'name': name, 'email': email, 'password': password},
        withAuth: false,
      );
      final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
      final token = res['token'] as String;
      await _persist(user, token);
      return ApiResponse.success(user.copyWith(token: token),
          message: res['message'] as String?);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    try {
      final res = await ApiProvider.post(
        '/auth/login',
        {'email': email, 'password': password},
        withAuth: false,
      );
      final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
      final token = res['token'] as String;
      await _persist(user, token);
      return ApiResponse.success(user.copyWith(token: token),
          message: res['message'] as String?);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> logout() async {
    try {
      await ApiProvider.post('/auth/logout', {});
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    return ApiResponse.success(true);
  }

  Future<(UserModel?, String?)> loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      final userJson = prefs.getString(AppConstants.userKey);
      if (token == null || userJson == null) return (null, null);
      final user = UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>);
      return (user, token);
    } catch (_) {
      return (null, null);
    }
  }

  Future<void> _persist(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }
}
