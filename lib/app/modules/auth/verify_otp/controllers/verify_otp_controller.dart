import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class VerifyOtpController extends GetxController {
  final AuthRepository repository;
  VerifyOtpController({required this.repository});

  late final String email;
  final otpCtrl = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final canResend = false.obs;
  final resendSeconds = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] as String? ?? '';
    _startResendTimer();
    otpCtrl.addListener(() {
      if (errorMessage.value.isNotEmpty) errorMessage('');
    });
  }

  @override
  void onClose() {
    otpCtrl.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _startResendTimer() {
    canResend(false);
    resendSeconds(60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds.value <= 1) {
        t.cancel();
        canResend(true);
        resendSeconds(0);
      } else {
        resendSeconds(resendSeconds.value - 1);
      }
    });
  }

  Future<void> verify() async {
    if (isLoading.value) return;
    final code = otpCtrl.text.trim();
    if (code.length < 6) {
      errorMessage('Masukkan 6 digit kode OTP.');
      return;
    }
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.verifyOtp(email, code);
      if (result.success) {
        Get.offAllNamed(Routes.BERANDA);
      } else {
        errorMessage(result.message ?? 'Verifikasi gagal.');
        otpCtrl.clear();
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> resend() async {
    if (!canResend.value || isLoading.value) return;
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.resendOtp(email);
      if (result.success) {
        otpCtrl.clear();
        _startResendTimer();
        Get.snackbar(
          'Berhasil',
          'Kode OTP baru telah dikirim ke email Anda.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        errorMessage(result.message ?? 'Gagal mengirim ulang OTP.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }
}
