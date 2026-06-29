import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_text_field.dart';
import '../controllers/analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }
        return Column(
          children: [
            _Header(petName: controller.petName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: _cardDeco(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label(
                              icon: Icons.monitor_weight_outlined,
                              text: 'Berat Badan Saat Ini'),
                          const SizedBox(height: 8),
                          PawTextField(
                            controller: controller.weightCtrl,
                            label: 'Berat (kg)',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixIcon: Icons.scale_outlined,
                          ),
                          const SizedBox(height: 18),
                          const _Label(
                              icon: Icons.directions_run_rounded,
                              text: 'Tingkat Aktivitas Harian'),
                          const SizedBox(height: 10),
                          Obx(() => Column(
                                children: [
                                  _ActivityTile(
                                    value: 'inactive',
                                    icon: Icons.weekend_rounded,
                                    title: 'Kurang Aktif',
                                    subtitle:
                                        'Di dalam rumah, tidak banyak bergerak',
                                    selected: controller.activityLevel.value ==
                                        'inactive',
                                    onTap: () => controller
                                        .activityLevel.value = 'inactive',
                                  ),
                                  const SizedBox(height: 8),
                                  _ActivityTile(
                                    value: 'active',
                                    icon: Icons.directions_run_rounded,
                                    title: 'Aktif',
                                    subtitle:
                                        'Rutin bergerak, bermain, atau diajak jalan',
                                    selected: controller.activityLevel.value ==
                                        'active',
                                    onTap: () =>
                                        controller.activityLevel.value = 'active',
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      if (controller.errorMessage.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _ErrorBox(message: controller.errorMessage.value);
                    }),
                    PawButton(
                      label: 'Analisis Sekarang',
                      icon: Icons.analytics_rounded,
                      onTap: controller.analyze,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

BoxDecoration _cardDeco() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.055),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );

class _Header extends StatelessWidget {
  final String petName;
  const _Header({required this.petName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 48, 18),
          child: Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textDark, size: 20),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Analisis Kondisi',
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                        petName.isEmpty
                            ? 'Masukkan berat & aktivitas terkini'
                            : 'untuk $petName',
                        style: const TextStyle(
                            color: AppColors.textDark, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Label({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMedium.withValues(alpha: 0.8)),
        const SizedBox(width: 7),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium,
                fontSize: 13)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String value;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _ActivityTile({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.secondary.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon,
                  size: 19,
                  color: selected ? AppColors.accent : AppColors.textMedium),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textMedium)),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.accent : AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: AppColors.error, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.monitor_heart_rounded,
                  color: AppColors.textDark, size: 40),
            ),
            const SizedBox(height: 24),
            const Text('Menghitung kondisi tubuh...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Menganalisis BCS, RER, MER & rekomendasi nutrisi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
