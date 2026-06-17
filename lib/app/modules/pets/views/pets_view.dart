import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/paw_empty_widget.dart';
import '../../../widgets/paw_error_widget.dart';
import '../../../widgets/paw_loading_widget.dart';
import '../../../widgets/pet_list_card.dart';
import '../controllers/pets_controller.dart';

class PetsView extends GetView<PetsController> {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hewan Peliharaan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.swipe_left_rounded,
                                size: 13, color: AppColors.textLight),
                            const SizedBox(width: 4),
                            const Text(
                              'Geser ke kiri untuk hapus',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const PawLoadingWidget(
                      message: 'Memuat hewan peliharaan...');
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return PawErrorWidget(
                    message: controller.errorMessage.value,
                    onRetry: controller.loadPets,
                  );
                }
                if (controller.pets.isEmpty) {
                  return PawEmptyWidget(
                    message:
                        'Belum ada hewan peliharaan.\nAnalisis hewan untuk menyimpannya.',
                    icon: Icons.pets,
                    actionLabel: 'Mulai Analisis',
                    onAction: () => Get.toNamed(Routes.ANALYSIS),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.loadPets,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: controller.pets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final pet = controller.pets[i];
                      return Dismissible(
                        key: Key('pet_${pet.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete_rounded,
                              color: AppColors.error),
                        ),
                        confirmDismiss: (_) => Get.dialog<bool>(
                          Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            backgroundColor: Colors.white,
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 28),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: 26),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Hapus Hewan?',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Hapus ${pet.name}? Semua riwayat analisis juga akan ikut terhapus dan tidak bisa dikembalikan.',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMedium,
                                        height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          style: OutlinedButton.styleFrom(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 14),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                            side: const BorderSide(
                                                color: Color(0xFFE0E0E0),
                                                width: 1.5),
                                          ),
                                          child: const Text(
                                            'Batal',
                                            style: TextStyle(
                                                color: AppColors.textMedium,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.error,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 14),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (_) => controller.deletePet(pet.id),
                        child: PetListCard(
                          pet: pet,
                          onTap: () =>
                              Get.toNamed(Routes.PET_DETAIL, arguments: pet),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.ANALYSIS),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
