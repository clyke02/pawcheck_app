import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/analysis_model.dart';
import 'pet_detail_controller.dart';

class PetDetailView extends GetView<PetDetailController> {
  const PetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pet = controller.pet.value;
      if (pet == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      return Scaffold(
        appBar: AppBar(
          title: Text(pet.name),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pet.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                        Text(
                          '${pet.breed?.name ?? 'Unknown'} • ${pet.genderLabel}',
                          style: const TextStyle(color: AppColors.textMedium),
                        ),
                        Text(
                          pet.breed?.species == 'cat' ? 'Kucing' : 'Anjing',
                          style: const TextStyle(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Riwayat Analisis',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator())
              else if (pet.analyses.isEmpty)
                const Text('Belum ada riwayat analisis.',
                    style: TextStyle(color: AppColors.textMedium))
              else
                ...pet.analyses.map((a) => _AnalysisHistoryCard(analysis: a)),
            ],
          ),
        ),
      );
    });
  }
}

class _AnalysisHistoryCard extends StatelessWidget {
  final AnalysisModel analysis;
  const _AnalysisHistoryCard({required this.analysis});

  Color get _bcsColor {
    switch (analysis.bcsScore) {
      case 3: return AppColors.success;
      case 1:
      case 2: return const Color(0xFF2196F3);
      case 4: return const Color(0xFFFF9800);
      default: return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _bcsColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(analysis.bcsEmoji,
                style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BCS ${analysis.bcsScore} • ${analysis.bcsCategory}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: _bcsColor),
                ),
                Text(
                  '${analysis.weightKg} kg • MER ${analysis.mer} kkal',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(analysis.createdAt),
            style: const TextStyle(
                fontSize: 11, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
