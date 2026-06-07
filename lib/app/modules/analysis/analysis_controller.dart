import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/analysis_model.dart';
import '../../data/repositories/analysis_repository.dart';
import '../../routes/app_pages.dart';

class AnalysisController extends GetxController {
  final _repo = AnalysisRepository();
  final _picker = ImagePicker();

  final selectedImage = Rxn<File>();
  final weightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final selectedGender = 'male'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final analysisResult = Rxn<AnalysisModel>();

  @override
  void onClose() {
    weightCtrl.dispose();
    ageCtrl.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      errorMessage('Gagal memilih foto: ${e.toString()}');
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Sumber Foto',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Kamera'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Galeri'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> analyze() async {
    errorMessage('');
    if (selectedImage.value == null) {
      errorMessage('Pilih foto terlebih dahulu.');
      return;
    }
    final weight = double.tryParse(weightCtrl.text.trim());
    final age = double.tryParse(ageCtrl.text.trim());
    if (weight == null || weight <= 0) {
      errorMessage('Masukkan berat badan yang valid.');
      return;
    }
    if (age == null || age < 0) {
      errorMessage('Masukkan usia yang valid.');
      return;
    }
    try {
      isLoading(true);
      final result = await _repo.analyze(
        image: selectedImage.value!,
        weightKg: weight,
        ageYears: age,
        gender: selectedGender.value,
      );
      if (result.success) {
        analysisResult.value = result.data;
        Get.toNamed(Routes.analysisResult);
      } else {
        errorMessage(result.message ?? 'Analisis gagal.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void reset() {
    selectedImage.value = null;
    weightCtrl.clear();
    ageCtrl.clear();
    selectedGender.value = 'male';
    analysisResult.value = null;
    errorMessage('');
  }
}
