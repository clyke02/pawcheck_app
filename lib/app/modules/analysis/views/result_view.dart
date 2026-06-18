import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/bcs_score_card.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_loading_widget.dart';
import '../controllers/analysis_result_controller.dart';

class ResultView extends GetView<AnalysisResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = controller.analysis.value;
      if (result == null) {
        return const Scaffold(body: PawLoadingWidget());
      }
      final isView = result.petId != null;

      final headerWidget = SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
          child: Row(
            children: [
              if (isView)
                IconButton(
                  onPressed: controller.done,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                )
              else
                const SizedBox(height: 48),
            ],
          ),
        ),
      );

      return Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BcsScoreCard(
                      heroMode: true,
                      headerWidget: headerWidget,
                      score: result.bcsScore,
                      category: result.bcsCategory,
                      weightKg: result.weightKg,
                      idealWeightUsed: result.idealWeightUsed,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RerMerCard(rer: result.rer, mer: result.mer),
                          const SizedBox(height: 14),
                          _BreedCard(
                            breed: result.breedPrediction,
                            confidence: result.confidencePercent,
                          ),
                          const SizedBox(height: 14),
                          _DetailCard(
                            ageYears: result.ageYears,
                            gender: result.gender,
                          ),
                          const SizedBox(height: 14),
                          _NutritionCard(
                              nutritionRec: result.nutritionRecommendation),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomActions(controller: controller, isView: isView),
          ],
        ),
      );
    });
  }
}

class _BottomActions extends StatelessWidget {
  final AnalysisResultController controller;
  final bool isView;
  const _BottomActions({required this.controller, required this.isView});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isView) ...[
                Obx(() => PawButton(
                      label: 'Simpan sebagai Hewan Peliharaan',
                      onTap: controller.savePet,
                      isLoading: controller.isSaving.value,
                      icon: Icons.pets,
                    )),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  Expanded(
                    child: PawButton(
                      label: 'Analisis Lagi',
                      isOutlined: true,
                      onTap: controller.analisisLagi,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PawButton(
                      label: 'Selesai',
                      isOutlined: true,
                      onTap: controller.done,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class _RerMerCard extends StatelessWidget {
  final double rer;
  final double mer;
  const _RerMerCard({required this.rer, required this.mer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(),
      child: Column(
        children: [
          _EnergyRow(
            icon: Icons.bedtime_outlined,
            label: 'RER',
            subtitle: 'Kebutuhan Energi Istirahat',
            value: '${rer.toStringAsFixed(0)} kkal/hari',
            color: const Color(0xFF5C6BC0),
          ),
          Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey.withValues(alpha: 0.15)),
          _EnergyRow(
            icon: Icons.local_fire_department_rounded,
            label: 'MER',
            subtitle: 'Kebutuhan Energi Harian',
            value: '${mer.toStringAsFixed(0)} kkal/hari',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _EnergyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String value;
  final Color color;

  const _EnergyRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textDark)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMedium)),
              ],
            ),
          ),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _BreedCard extends StatelessWidget {
  final String breed;
  final String confidence;
  const _BreedCard({required this.breed, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.biotech_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Prediksi Ras',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textMedium)),
                Text(breed,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              confidence,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final double ageYears;
  final String gender;
  const _DetailCard({required this.ageYears, required this.gender});

  @override
  Widget build(BuildContext context) {
    final ageLabel =
        ageYears % 1 == 0 ? '${ageYears.toInt()} tahun' : '$ageYears tahun';
    final genderLabel = gender == 'male' ? 'Jantan' : 'Betina';

    return Container(
      decoration: _cardDeco(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.cake_outlined,
              label: 'Usia',
              value: ageLabel,
            ),
          ),
          Container(
              width: 1,
              height: 44,
              color: Colors.grey.withValues(alpha: 0.18)),
          Expanded(
            child: _StatItem(
              icon: gender == 'male'
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              label: 'Jenis Kelamin',
              value: genderLabel,
              iconColor: gender == 'male'
                  ? const Color(0xFF42A5F5)
                  : const Color(0xFFEC407A),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String? nutritionRec;
  const _NutritionCard({required this.nutritionRec});

  @override
  Widget build(BuildContext context) {
    if (nutritionRec == null || nutritionRec!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: _cardDeco(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Rekomendasi Nutrisi',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),
          const SizedBox(height: 14),
          MarkdownBody(
            data: nutritionRec!,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  height: 1.55),
              listBullet: const TextStyle(
                  fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
