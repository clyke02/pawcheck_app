import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthRepository repository;
  RegisterController({required this.repository});

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

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
      errorMessage('Semua field wajib diisi.');
      return;
    }
    if (password.length < 8) {
      errorMessage('Password minimal 8 karakter.');
      return;
    }
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.register(name, email, password);
      if (result.success) {
        Get.offAllNamed(Routes.MAIN);
      } else {
        errorMessage(result.message ?? 'Registrasi gagal.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
