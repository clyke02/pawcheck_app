import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/analysis_history_card.dart';
import '../../widgets/paw_error_widget.dart';
import '../../widgets/paw_loading_widget.dart';
import 'pet_detail_controller.dart';

class PetDetailView extends GetView<PetDetailController> {
  const PetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final pet = controller.pet.value;

        if (pet == null && controller.isLoading.value) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            backgroundColor: AppColors.background,
            body: const PawLoadingWidget(message: 'Memuat detail...'),
          );
        }

        if (pet == null && controller.errorMessage.value.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            backgroundColor: AppColors.background,
            body: PawErrorWidget(
              message: controller.errorMessage.value,
              onRetry: Get.back,
            ),
          );
        }

        if (pet == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(pet.name),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: controller.showEditNameDialog,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(pet.speciesEmoji,
                          style: const TextStyle(fontSize: 56)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            Text(
                              '${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                              style: const TextStyle(
                                  color: AppColors.textMedium),
                            ),
                            Text(
                              pet.breed?.species == 'cat'
                                  ? 'Kucing'
                                  : 'Anjing',
                              style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Riwayat Analisis',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                if (controller.isLoading.value)
                  const PawLoadingWidget()
                else if (controller.errorMessage.value.isNotEmpty)
                  PawErrorWidget(
                    message: controller.errorMessage.value,
                    onRetry: () => controller.loadPetDetail(pet.id),
                  )
                else if ((pet.analyses ?? []).isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Belum ada riwayat analisis.',
                        style: TextStyle(color: AppColors.textMedium),
                      ),
                    ),
                  )
                else
                  ...((pet.analyses ?? []).map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AnalysisHistoryCard(analysis: a),
                      ))),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
