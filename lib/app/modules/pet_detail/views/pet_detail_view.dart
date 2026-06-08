import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/analysis_history_card.dart';
import '../../../widgets/paw_app_bar.dart';
import '../../../widgets/paw_error_widget.dart';
import '../../../widgets/paw_loading_widget.dart';
import '../controllers/pet_detail_controller.dart';

class PetDetailView extends GetView<PetDetailController> {
  const PetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pet = controller.pet.value;

      if (pet == null && controller.isLoading.value) {
        return Scaffold(
          appBar: const PawAppBar(title: ''),
          backgroundColor: AppColors.background,
          body: const PawLoadingWidget(message: 'Memuat detail...'),
        );
      }

      if (pet == null && controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          appBar: const PawAppBar(title: 'Detail Hewan'),
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
        appBar: PawAppBar(
          title: pet.name,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Ubah Nama',
              onPressed: controller.showEditNameDialog,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Hapus',
              onPressed: controller.deletePet,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient hero card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF9060)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(pet.speciesEmoji,
                            style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pet.breed?.species == 'cat'
                                  ? 'Kucing'
                                  : 'Anjing',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Riwayat Analisis',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ),
              const SizedBox(height: 12),

              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: PawLoadingWidget(),
                )
              else if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PawErrorWidget(
                    message: controller.errorMessage.value,
                    onRetry: () => controller.loadPetDetail(pet.id),
                  ),
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: AnalysisHistoryCard(
                        analysis: a,
                        onTap: () => Get.toNamed(
                          Routes.ANALYSIS_RESULT,
                          arguments: a,
                        ),
                      ),
                    ))),
            ],
          ),
        ),
      );
    });
  }
}
