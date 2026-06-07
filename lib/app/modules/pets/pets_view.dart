import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../widgets/paw_empty_widget.dart';
import '../../widgets/paw_error_widget.dart';
import '../../widgets/paw_loading_widget.dart';
import '../../widgets/pet_list_card.dart';
import 'pets_controller.dart';

class PetsView extends GetView<PetsController> {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hewan Peliharaan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const PawLoadingWidget(message: 'Memuat hewan peliharaan...');
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
            padding: const EdgeInsets.all(16),
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
                confirmDismiss: (_) async {
                  bool confirmed = false;
                  await Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text('Hapus Hewan?'),
                      content: Text(
                          'Hapus ${pet.name}? Semua riwayat analisis juga akan terhapus.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              confirmed = false;
                              Get.back();
                            },
                            child: const Text('Batal')),
                        TextButton(
                          onPressed: () {
                            confirmed = true;
                            Get.back();
                          },
                          child: const Text('Hapus',
                              style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                  return confirmed;
                },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.ANALYSIS),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

