import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/constants.dart';

class AuthRepository {
  Future<(UserModel, String)> register(String name, String email, String password) async {
    final res = await ApiProvider.post(
      '/auth/register',
      {'name': name, 'email': email, 'password': password},
      withAuth: false,
    );
    final user = UserModel.fromJson(res['user']);
    final token = res['token'] as String;
    await _persist(user, token);
    return (user, token);
  }

  Future<(UserModel, String)> login(String email, String password) async {
    final res = await ApiProvider.post(
      '/auth/login',
      {'email': email, 'password': password},
      withAuth: false,
    );
    final user = UserModel.fromJson(res['user']);
    final token = res['token'] as String;
    await _persist(user, token);
    return (user, token);
  }

  Future<void> logout() async {
    try {
      await ApiProvider.post('/auth/logout', {});
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  Future<(UserModel?, String?)> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    final userJson = prefs.getString(AppConstants.userKey);
    if (token == null || userJson == null) return (null, null);
    final user = UserModel.fromJson(jsonDecode(userJson));
    return (user, token);
  }

  Future<void> _persist(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }
}
