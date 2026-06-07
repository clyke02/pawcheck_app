import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../widgets/paw_loading_widget.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PawCheck'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() => controller.isLoading.value
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'Keluar',
                  onPressed: controller.logout,
                )),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const PawLoadingWidget(message: 'Memuat...');
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${controller.user.value?.name ?? ''}! 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Apa yang ingin kamu lakukan hari ini?',
                  style: TextStyle(color: AppColors.textMedium),
                ),
                const SizedBox(height: 32),
                _MenuCard(
                  icon: Icons.camera_alt_rounded,
                  title: 'Analisis BCS',
                  subtitle: 'Foto hewan & cek kondisi tubuhnya',
                  color: AppColors.primary,
                  onTap: () => Get.toNamed(Routes.analysis),
                ),
                const SizedBox(height: 16),
                _MenuCard(
                  icon: Icons.pets,
                  title: 'Hewan Peliharaan',
                  subtitle: 'Lihat & kelola daftar hewanmu',
                  color: AppColors.accent,
                  onTap: () => Get.toNamed(Routes.pets),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text('🐾', style: TextStyle(fontSize: 36)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Body Condition Score',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'BCS mengukur kondisi ideal tubuh hewanmu dari skala 1-5 berdasarkan berat & ras.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textMedium, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
