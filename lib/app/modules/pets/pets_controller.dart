import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

class PetsController extends GetxController {
  final _repo = PetRepository();
  final pets = <PetModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Handle create-from-analysis flow
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['createFromAnalysis'] == true) {
      _createFromAnalysis(args['name'] as String, args['analysisId'] as int);
    } else {
      loadPets();
    }
  }

  Future<void> loadPets() async {
    isLoading.value = true;
    try {
      pets.value = await _repo.getPets();
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createFromAnalysis(String name, int analysisId) async {
    try {
      await _repo.createPet(name, analysisId);
      Get.snackbar('Berhasil', '$name berhasil disimpan!',
          backgroundColor: Colors.green[100]);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.red[100]);
    }
    await loadPets();
  }

  Future<void> deletePet(int id) async {
    try {
      await _repo.deletePet(id);
      pets.removeWhere((p) => p.id == id);
      Get.snackbar('Berhasil', 'Hewan dihapus.',
          backgroundColor: Colors.green[100]);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[100]);
    }
  }

  void confirmDelete(PetModel pet) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Hewan?'),
        content: Text(
            'Hapus ${pet.name}? Semua riwayat analisis juga akan terhapus.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Get.back();
              deletePet(pet.id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

