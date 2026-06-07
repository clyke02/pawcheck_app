import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _repo = AuthRepository();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      errorMessage('Email dan password wajib diisi.');
      return;
    }
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repo.login(email, password);
      if (result.success) {
        Get.offAllNamed(Routes.home);
      } else {
        errorMessage(result.message ?? 'Login gagal.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
