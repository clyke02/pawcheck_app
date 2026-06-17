import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/models/pet_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/analysis_history_card.dart';
import '../../../widgets/bcs_score_card.dart';
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
        return const Scaffold(
          body: PawLoadingWidget(message: 'Memuat detail...'),
        );
      }

      if (pet == null && controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          body: SafeArea(
            child: PawErrorWidget(
              message: controller.errorMessage.value,
              onRetry: Get.back,
            ),
          ),
        );
      }

      if (pet == null) return const SizedBox.shrink();

      return Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PetHeroCard(pet: pet, controller: controller),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Analisis',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    const SizedBox(height: 12),
                    if (controller.isLoading.value)
                      const Center(child: PawLoadingWidget())
                    else if (controller.errorMessage.value.isNotEmpty)
                      PawErrorWidget(
                        message: controller.errorMessage.value,
                        onRetry: () => controller.loadPetDetail(pet.id),
                      )
                    else if ((pet.analyses ?? []).isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'Belum ada riwayat analisis.',
                            style:
                                TextStyle(color: AppColors.textMedium),
                          ),
                        ),
                      )
                    else
                      ...((pet.analyses ?? []).map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AnalysisHistoryCard(
                            analysis: a,
                            onTap: () => Get.toNamed(
                              Routes.ANALYSIS_RESULT,
                              arguments: a,
                            ),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PetHeroCard extends StatelessWidget {
  final PetModel pet;
  final PetDetailController controller;

  const _PetHeroCard({required this.pet, required this.controller});

  @override
  Widget build(BuildContext context) {
    final latest = pet.latestAnalysis;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF9060)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Navigation row
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.showEditNameDialog,
                    tooltip: 'Ubah Nama',
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 20),
                  ),
                  IconButton(
                    onPressed: controller.deletePet,
                    tooltip: 'Hapus',
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Pet info
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5),
                  ),
                  child: Center(
                    child: Text(pet.speciesEmoji,
                        style: const TextStyle(fontSize: 44)),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children: [
                          _HeroBadge(pet.speciesLabel),
                          if (latest != null)
                            _HeroBadge(
                              'BCS ${latest.bcsScore} · ${latest.bcsCategory}',
                              color: BcsScoreCard.colorForScore(
                                  latest.bcsScore),
                            ),
                        ],
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
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final Color? color;
  const _HeroBadge(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color != null
            ? color!.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color != null
              ? color!.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
