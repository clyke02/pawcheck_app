import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

class PetsController extends GetxController {
  final _repo = PetRepository();

  final pets = <PetModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['createFromAnalysis'] == true) {
      _createFromAnalysis(
        args['name'] as String,
        args['analysisId'] as int,
      );
    } else {
      loadPets();
    }
  }

  Future<void> loadPets() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repo.getPets();
      if (result.success) {
        pets.value = result.data ?? [];
      } else {
        errorMessage(result.message ?? 'Gagal memuat data.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _createFromAnalysis(String name, int analysisId) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repo.createPet(name, analysisId);
      if (result.success) {
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
      isLoading(false);
    }
    await loadPets();
  }

  Future<void> deletePet(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repo.deletePet(id);
      if (result.success) {
        pets.removeWhere((p) => p.id == id);
        Get.snackbar(
          'Berhasil',
          'Hewan peliharaan dihapus.',
          backgroundColor: AppColors.accent,
          colorText: AppColors.textDark,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        errorMessage(result.message ?? 'Gagal menghapus hewan.');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void confirmDelete(PetModel pet) {
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Hewan?'),
        content: Text(
            'Hapus ${pet.name}? Semua riwayat analisis juga akan terhapus.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              deletePet(pet.id);
            },
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
