import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/constants.dart';
import '../../../data/models/pet_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/analysis_history_card.dart';
import '../../../widgets/bcs_score_card.dart';
import '../../../widgets/paw_button.dart';
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
            body: PawLoadingWidget(message: 'Memuat detail...'));
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
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PetHeroCard(pet: pet, controller: controller),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PawButton(
                      label: 'Analisis Kondisi',
                      icon: Icons.monitor_heart_rounded,
                      onTap: controller.analisis,
                    ),
                    const SizedBox(height: 24),
                    const Text('Riwayat Analisis',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17)),
                    const SizedBox(height: 12),
                    if ((pet.analyses ?? []).isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'Belum ada riwayat analisis.\nLakukan analisis pertama.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMedium),
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
                              arguments: {'analysis': a},
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
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textDark, size: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.showEditNameDialog,
                    tooltip: 'Ubah Nama',
                    icon: const Icon(Icons.edit_rounded,
                        color: AppColors.textDark, size: 20),
                  ),
                  IconButton(
                    onPressed: controller.deletePet,
                    tooltip: 'Hapus',
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.textDark, size: 20),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Row(
              children: [
                _Avatar(pet: pet),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pet.name,
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                          '${pet.breed?.name ?? 'Unknown'} · ${pet.genderLabel}',
                          style: TextStyle(
                              color:
                                  AppColors.textDark.withValues(alpha: 0.7),
                              fontSize: 13)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _Badge('${pet.speciesLabel} · ${pet.currentAgeLabel}'),
                          _Badge(pet.neuterLabel),
                          if (latest != null)
                            _Badge(
                              'BCS ${latest.bcsScore} · ${latest.bcsCategory}',
                              color:
                                  BcsScoreCard.colorForScore(latest.bcsScore),
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

class _Avatar extends StatelessWidget {
  final PetModel pet;
  const _Avatar({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.textDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.textDark.withValues(alpha: 0.15), width: 1.5),
      ),
      child: (pet.imageUrl != null && pet.imageUrl!.isNotEmpty)
          ? Image.network(
              AppConstants.fileUrl(pet.imageUrl!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _emoji(),
            )
          : _emoji(),
    );
  }

  Widget _emoji() =>
      Center(child: Text(pet.speciesEmoji, style: const TextStyle(fontSize: 44)));
}

class _Badge extends StatelessWidget {
  final String label;
  final Color? color;
  const _Badge(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color != null
            ? color!.withValues(alpha: 0.15)
            : AppColors.textDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color != null
              ? color!.withValues(alpha: 0.4)
              : AppColors.textDark.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Text(label,
          style: TextStyle(
              color: color ?? AppColors.textDark,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    );
  }
}
