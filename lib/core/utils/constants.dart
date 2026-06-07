import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static final String baseUrl = '${_resolveBaseUrl()}/api';

  static String _resolveBaseUrl() {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) {
      // Emulator Android  → 'http://10.0.2.2:8000'
      // HP fisik (LAN/WiFi sama-network dengan laptop):
      return 'http://192.168.110.3:8000';
    }
    if (Platform.isIOS) return 'http://localhost:8000';
    return 'http://localhost:8000';
  }

  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';
}
