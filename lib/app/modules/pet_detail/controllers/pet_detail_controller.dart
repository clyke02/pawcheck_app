import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/pet_repository.dart';

class PetDetailController extends GetxController {
  final PetRepository repository;
  PetDetailController({required this.repository});

  final pet = Rxn<PetModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final nameCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is PetModel) {
      pet.value = arg;
      nameCtrl.text = arg.name;
      loadPetDetail(arg.id);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }

  Future<void> loadPetDetail(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.getPet(id);
      if (result.success) {
        pet.value = result.data;
      } else {
        errorMessage(result.message ?? 'Gagal memuat detail.');
      }
    } catch (e) {
      errorMessage('Gagal memuat detail hewan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateName() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty || name == pet.value?.name) {
      Get.back();
      return;
    }
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.updatePet(pet.value!.id, name);
      if (result.success) {
        pet.value = result.data;
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Nama berhasil diperbarui.',
          backgroundColor: AppColors.accent,
          colorText: AppColors.textDark,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        errorMessage(result.message ?? 'Gagal memperbarui nama.');
      }
    } catch (e) {
      errorMessage('Gagal mengubah nama, coba lagi.');
    } finally {
      isLoading(false);
    }
  }

  void showEditNameDialog() {
    nameCtrl.text = pet.value?.name ?? '';
    errorMessage('');
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            labelText: 'Nama hewan',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
            onPressed: updateName,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
