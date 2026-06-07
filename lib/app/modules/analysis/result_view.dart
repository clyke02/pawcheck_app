import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/analysis_model.dart';
import '../../routes/app_pages.dart';
import '../../widgets/bcs_score_card.dart';
import '../../widgets/paw_button.dart';
import '../../widgets/paw_card.dart';
import 'analysis_controller.dart';

class ResultView extends GetView<AnalysisController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = controller.analysisResult.value;
      if (result == null) return const SizedBox.shrink();
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Hasil Analisis'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                controller.reset();
                Get.offAllNamed(Routes.home);
              },
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
              _BreedChip(result: result),
              const SizedBox(height: 16),
              _InfoCard(result: result),
              const SizedBox(height: 16),
              _NutritionCard(result: result),
              const SizedBox(height: 24),
              PawButton(
                label: 'Simpan sebagai Hewan Peliharaan',
                onTap: () => _showAddPetDialog(context, result),
                icon: Icons.pets,
              ),
              const SizedBox(height: 12),
              PawButton(
                label: 'Analisis Lagi',
                isOutlined: true,
                onTap: () {
                  controller.reset();
                  Get.back();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  void _showAddPetDialog(BuildContext context, AnalysisModel result) {
    final nameCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Beri Nama Hewanmu'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama hewan'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              Get.back();
              Get.toNamed(Routes.pets, arguments: {
                'createFromAnalysis': true,
                'name': name,
                'analysisId': result.id,
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _BreedChip extends StatelessWidget {
  final AnalysisModel result;
  const _BreedChip({required this.result});

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
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textMedium)),
                Text(
                  result.breedPrediction,
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
              result.confidencePercent,
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
  final AnalysisModel result;
  const _InfoCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return PawCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Pengukuran',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const Divider(height: 20),
          _Row('Berat Aktual', '${result.weightKg} kg'),
          _Row('Berat Ideal', '${result.idealWeightUsed} kg'),
          _Row('RER', '${result.rer.toStringAsFixed(0)} kkal/hari'),
          _Row('MER', '${result.mer.toStringAsFixed(0)} kkal/hari'),
          _Row('Usia', '${result.ageYears} tahun'),
          _Row('Gender',
              result.gender == 'male' ? 'Jantan' : 'Betina'),
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
  final AnalysisModel result;
  const _NutritionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final rec = result.nutritionRecommendation;
    if (rec == null || rec.isEmpty) return const SizedBox.shrink();
    return PawCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_rounded,
                  color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Rekomendasi Nutrisi',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
          const Divider(height: 20),
          MarkdownBody(
            data: rec,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                  fontSize: 13, color: AppColors.textDark),
              listBullet: const TextStyle(
                  fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
