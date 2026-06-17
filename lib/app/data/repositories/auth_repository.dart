import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/repository_helper.dart';

class AuthRepository with RepositoryHelper {
  Future<ApiResponse<bool>> register(
          String name, String email, String password) =>
      guard(() async {
        final res = await ApiProvider.post(
          '/auth/register',
          {'name': name, 'email': email, 'password': password},
          withAuth: false,
          timeout: const Duration(seconds: 30),
        );
        return ApiResponse.success(true, message: res['message'] as String?);
      });

  Future<ApiResponse<UserModel>> login(String email, String password) =>
      guard(() async {
        final res = await ApiProvider.post(
          '/auth/login',
          {'email': email, 'password': password},
          withAuth: false,
          timeout: const Duration(seconds: 30),
        );
        final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
        final token = res['token'] as String;
        await _persist(user, token);
        return ApiResponse.success(user.copyWith(token: token),
            message: res['message'] as String?);
      });

  Future<ApiResponse<UserModel>> verifyOtp(String email, String otp) =>
      guard(() async {
        final res = await ApiProvider.post(
          '/auth/verify-otp',
          {'email': email, 'otp': otp},
          withAuth: false,
        );
        final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
        final token = res['token'] as String;
        await _persist(user, token);
        return ApiResponse.success(user.copyWith(token: token),
            message: res['message'] as String?);
      });

  Future<ApiResponse<bool>> resendOtp(String email) => guard(() async {
        final res = await ApiProvider.post(
          '/auth/resend-otp',
          {'email': email},
          withAuth: false,
          timeout: const Duration(seconds: 30),
        );
        return ApiResponse.success(true, message: res['message'] as String?);
      });

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
      final user =
          UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
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
