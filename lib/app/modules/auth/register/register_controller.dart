import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final _repo = AuthRepository();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi.',
          backgroundColor: Colors.red[100]);
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Error', 'Password minimal 8 karakter.',
          backgroundColor: Colors.red[100]);
      return;
    }
    isLoading.value = true;
    try {
      await _repo.register(name, email, password);
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar('Registrasi Gagal', e.toString(),
          backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
  }
}
