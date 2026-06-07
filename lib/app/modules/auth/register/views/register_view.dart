import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../widgets/paw_button.dart';
import '../../../../widgets/paw_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buat Akun'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat datang!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const Text(
                'Daftarkan akun untuk mulai.',
                style: TextStyle(fontSize: 14, color: AppColors.textMedium),
              ),
              const SizedBox(height: 32),
              PawTextField(
                controller: controller.nameCtrl,
                label: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              PawTextField(
                controller: controller.emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              PawTextField(
                controller: controller.passwordCtrl,
                label: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.errorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
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
              const SizedBox(height: 16),
              Obx(() => PawButton(
                    label: 'Daftar',
                    isLoading: controller.isLoading.value,
                    onTap: controller.register,
                    icon: Icons.person_add_rounded,
                  )),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: Get.back,
                  child: const Text(
                    'Sudah punya akun? Masuk',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
