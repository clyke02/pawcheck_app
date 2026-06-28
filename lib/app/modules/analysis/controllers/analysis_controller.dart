import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/analysis_repository.dart';
import '../../../routes/app_pages.dart';

class AnalysisController extends GetxController {
  final AnalysisRepository repository;
  AnalysisController({required this.repository});

  int petId = 0;
  String petName = '';

  final weightCtrl = TextEditingController();
  final activityLevel = 'average'.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Map) {
      petId = arg['petId'] as int? ?? 0;
      petName = arg['petName'] as String? ?? '';
    }
  }

  @override
  void onClose() {
    weightCtrl.dispose();
    super.onClose();
  }

  Future<void> analyze() async {
    errorMessage('');
    final weight =
        double.tryParse(weightCtrl.text.trim().replaceAll(',', '.'));
    if (weight == null || weight <= 0) {
      errorMessage('Masukkan berat badan yang valid.');
      return;
    }
    try {
      isLoading(true);
      final result = await repository.analyze(
        petId: petId,
        weightKg: weight,
        activityLevel: activityLevel.value,
      );
      if (result.success) {
        Get.toNamed(Routes.ANALYSIS_RESULT,
            arguments: {'analysis': result.data});
      } else {
        errorMessage(result.message ?? 'Analisis gagal.');
      }
    } catch (e) {
      errorMessage('Analisis gagal, mohon coba lagi.');
    } finally {
      isLoading(false);
    }
  }
}
