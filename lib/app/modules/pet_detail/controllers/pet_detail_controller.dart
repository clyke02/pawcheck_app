import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../widgets/paw_snackbar.dart';

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
        pet.value = pet.value!.copyWith(name: name);
        Get.back();
        PawSnackbar.success('Nama berhasil diperbarui.');
      } else {
        errorMessage(result.message ?? 'Gagal memperbarui nama.');
      }
    } catch (e) {
      errorMessage('Gagal mengubah nama, coba lagi.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePet() async {
    final petName = pet.value?.name ?? 'Hewan';
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Hewan?'),
        content: Text(
            'Hapus $petName? Semua riwayat analisis juga akan terhapus.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      isLoading(true);
      final result = await repository.deletePet(pet.value!.id);
      if (result.success) {
        Get.back();
        PawSnackbar.success('$petName berhasil dihapus.');
      } else {
        errorMessage(result.message ?? 'Gagal menghapus.');
      }
    } catch (e) {
      errorMessage('Gagal menghapus, coba lagi.');
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
