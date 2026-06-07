import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/bcs_score_card.dart';
import '../../../widgets/paw_button.dart';
import '../../../widgets/paw_card.dart';
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
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Hasil Analisis'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: controller.done,
              child: const Text('Selesai'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BcsScoreCard(
                score: result.bcsScore,
                category: result.bcsCategory,
                rer: result.rer,
                mer: result.mer,
              ),
              const SizedBox(height: 16),
              _BreedChip(
                breed: result.breedPrediction,
                confidence: result.confidencePercent,
              ),
              const SizedBox(height: 16),
              _InfoCard(result: result),
              const SizedBox(height: 16),
              _NutritionCard(nutritionRec: result.nutritionRecommendation),
              const SizedBox(height: 24),
              PawButton(
                label: 'Simpan sebagai Hewan Peliharaan',
                onTap: controller.showSaveSheet,
                icon: Icons.pets,
              ),
              const SizedBox(height: 12),
              PawButton(
                label: 'Analisis Lagi',
                isOutlined: true,
                onTap: Get.back,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }
}

class _BreedChip extends StatelessWidget {
  final String breed;
  final String confidence;
  const _BreedChip({required this.breed, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.biotech_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Prediksi Ras',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textMedium)),
                Text(
                  breed,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
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

class _InfoCard extends StatelessWidget {
  final dynamic result;
  const _InfoCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return PawCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Pengukuran',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Divider(height: 20),
          _Row('Berat Aktual', '${result.weightKg} kg'),
          _Row('Berat Ideal', '${result.idealWeightUsed} kg'),
          _Row('RER', '${result.rer.toStringAsFixed(0)} kkal/hari'),
          _Row('MER', '${result.mer.toStringAsFixed(0)} kkal/hari'),
          _Row('Usia', '${result.ageYears} tahun'),
          _Row('Gender', result.gender == 'male' ? 'Jantan' : 'Betina'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textMedium)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
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
    return PawCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_rounded,
                  color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('Rekomendasi Nutrisi',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const Divider(height: 20),
          MarkdownBody(
            data: nutritionRec!,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 13, color: AppColors.textDark),
              listBullet: const TextStyle(
                  fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
