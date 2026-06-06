import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/analysis_model.dart';
import '../../routes/app_pages.dart';
import 'analysis_controller.dart';

class ResultView extends GetView<AnalysisController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = controller.analysisResult.value;
      if (result == null) return const SizedBox.shrink();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Analisis'),
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
              _BcsCard(result: result),
              const SizedBox(height: 16),
              _InfoCard(result: result),
              const SizedBox(height: 16),
              _NutritionCard(result: result),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showAddPetDialog(context, result),
                icon: const Icon(Icons.pets),
                label: const Text('Simpan sebagai Hewan Peliharaan'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  controller.reset();
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Analisis Lagi'),
              ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Beri Nama Hewanmu'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama hewan'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
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

class _BcsCard extends StatelessWidget {
  final AnalysisModel result;
  const _BcsCard({required this.result});

  Color get _bcsColor {
    switch (result.bcsScore) {
      case 1: return const Color(0xFF2196F3);
      case 2: return const Color(0xFF03A9F4);
      case 3: return AppColors.success;
      case 4: return const Color(0xFFFF9800);
      default: return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bcsColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _bcsColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Text(result.bcsEmoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BCS ${result.bcsScore}/5',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: _bcsColor,
                  ),
                ),
                Text(
                  result.bcsCategory,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _bcsColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.breedPrediction} (${result.confidencePercent})',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
                ),
              ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Pengukuran',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const Divider(height: 20),
            _Row('Berat Aktual', '${result.weightKg} kg'),
            _Row('Berat Ideal', '${result.idealWeightUsed} kg'),
            _Row('RER', '${result.rer} kkal/hari'),
            _Row('MER', '${result.mer} kkal/hari'),
            _Row('Usia', '${result.ageYears} tahun'),
            _Row('Gender', result.gender == 'male' ? 'Jantan' : 'Betina'),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMedium)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekomendasi Nutrisi',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const Divider(height: 20),
            MarkdownBody(
              data: rec,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 13, color: AppColors.textDark),
                listBullet:
                    const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
