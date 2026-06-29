import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static final String baseUrl = '${_resolveBaseUrl()}/api';

  static String _resolveBaseUrl() {
    // Bisa di-override via: flutter run --dart-define=SERVER_IP=192.168.x.x
    const serverIp = String.fromEnvironment('SERVER_IP', defaultValue: '');
    if (serverIp.isNotEmpty) return 'http://$serverIp:8000';

    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) {
      // Emulator Android → http://10.0.2.2:8000
      // HP fisik WiFi rumah → 192.168.110.3
      // HP fisik Hotspot HP → cek IP laptop di jaringan hotspot
      return 'http://192.168.1.3:8000';
    }
    if (Platform.isIOS) return 'http://localhost:8000';
    return 'http://localhost:8000';
  }

  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';

  /// Build a full URL to a file served by the backend (e.g. /storage/...).
  static String fileUrl(String path) =>
      path.startsWith('http') ? path : '${_resolveBaseUrl()}$path';
}
