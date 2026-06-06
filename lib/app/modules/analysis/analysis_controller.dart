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

  final analysisResult = Rxn<AnalysisModel>();

  @override
  void onClose() {
    weightCtrl.dispose();
    ageCtrl.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked != null) selectedImage.value = File(picked.path);
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih Sumber Foto',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Galeri'),
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
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Pilih foto terlebih dahulu.',
          backgroundColor: Colors.red[100]);
      return;
    }
    final weight = double.tryParse(weightCtrl.text.trim());
    final age = double.tryParse(ageCtrl.text.trim());
    if (weight == null || age == null) {
      Get.snackbar('Error', 'Berat dan usia harus berupa angka.',
          backgroundColor: Colors.red[100]);
      return;
    }
    isLoading.value = true;
    try {
      final result = await _repo.analyze(
        image: selectedImage.value!,
        weightKg: weight,
        ageYears: age,
        gender: selectedGender.value,
      );
      analysisResult.value = result;
      Get.toNamed(Routes.analysisResult);
    } catch (e) {
      Get.snackbar('Analisis Gagal', e.toString(),
          backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    selectedImage.value = null;
    weightCtrl.clear();
    ageCtrl.clear();
    selectedGender.value = 'male';
    analysisResult.value = null;
  }
}
