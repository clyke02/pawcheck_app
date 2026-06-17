import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../widgets/paw_app_bar.dart';
import '../../../../widgets/paw_button.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0D0C8), width: 1.5),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.error, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PawAppBar(title: 'Verifikasi Email'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mark_email_unread_outlined,
                    size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cek Email Anda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode OTP 6 digit telah dikirim ke\n${controller.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFF9A825), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tidak menemukan email? Cek folder Spam atau Promosi di Gmail Anda.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7A5C00),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Obx(() => Pinput(
                    length: 6,
                    controller: controller.otpCtrl,
                    defaultPinTheme: defaultTheme,
                    focusedPinTheme: focusedTheme,
                    errorPinTheme: errorTheme,
                    keyboardType: TextInputType.number,
                    onCompleted: (_) => controller.verify(),
                    forceErrorState: controller.errorMessage.value.isNotEmpty,
                  )),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.errorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4, top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              Obx(() => PawButton(
                    label: 'Verifikasi',
                    isLoading: controller.isLoading.value,
                    onTap: controller.verify,
                    icon: Icons.verified_outlined,
                  )),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.canResend.value) {
                  return TextButton(
                    onPressed: controller.resend,
                    child: const Text(
                      'Kirim Ulang Kode',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  );
                }
                return Text(
                  'Kirim ulang kode dalam ${controller.resendSeconds.value}s',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
