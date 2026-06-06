import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _repo = AuthRepository();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

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
      Get.snackbar('Error', 'Email dan password wajib diisi.',
          backgroundColor: Colors.red[100]);
      return;
    }
    isLoading.value = true;
    try {
      await _repo.login(email, password);
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString(),
          backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
  }
}
