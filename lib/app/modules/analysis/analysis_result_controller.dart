import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/analysis_model.dart';
import '../../data/repositories/pet_repository.dart';
import '../../routes/app_pages.dart';

class AnalysisResultController extends GetxController {
  final PetRepository petRepository;
  AnalysisResultController({required this.petRepository});

  final analysis = Rxn<AnalysisModel>();
  final petNameCtrl = TextEditingController();
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is AnalysisModel) {
      analysis.value = arg;
    }
  }

  @override
  void onClose() {
    petNameCtrl.dispose();
    super.onClose();
  }

  Future<void> savePet() async {
    final name = petNameCtrl.text.trim();
    final id = analysis.value?.id;
    if (id == null || name.isEmpty) return;
    try {
      isSaving(true);
      errorMessage('');
      final result = await petRepository.createPet(name, id);
      if (result.success) {
        Get.back();
        Get.snackbar(
          'Berhasil!',
          '${result.data?.name ?? name} berhasil disimpan.',
          backgroundColor: AppColors.accent,
          colorText: AppColors.textDark,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        errorMessage(result.message ?? 'Gagal menyimpan hewan.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isSaving(false);
    }
  }

  void showSaveSheet() {
    petNameCtrl.clear();
    errorMessage('');
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Beri Nama Hewanmu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: petNameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Nama hewan'),
              autofocus: true,
            ),
            Obx(() {
              if (errorMessage.value.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage.value,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 12),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 40)),
                onPressed: isSaving.value ? null : savePet,
                child: isSaving.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              )),
        ],
      ),
    );
  }

  void done() {
    Get.offAllNamed(Routes.HOME);
  }
}
