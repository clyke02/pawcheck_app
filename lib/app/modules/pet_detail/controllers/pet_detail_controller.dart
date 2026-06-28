import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/paw_snackbar.dart';

class PetDetailController extends GetxController {
  final PetRepository repository;
  PetDetailController({required this.repository});

  final pet = Rxn<PetModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final dialogErrorMessage = ''.obs;
  final dialogIsLoading = false.obs;
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

  Future<void> analisis() async {
    final p = pet.value;
    if (p == null) return;
    await Get.toNamed(Routes.ANALYSIS, arguments: {
      'petId': p.id,
      'petName': p.name,
    });
    // Refresh history when returning from the analysis flow.
    loadPetDetail(p.id);
  }

  Future<void> updateName() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      dialogErrorMessage('Nama hewan wajib diisi.');
      return;
    }
    if (name == pet.value?.name) {
      dialogErrorMessage('Tidak ada perubahan pada nama.');
      return;
    }
    try {
      dialogIsLoading(true);
      dialogErrorMessage('');
      final result = await repository.updatePet(pet.value!.id, name);
      if (result.success) {
        pet.value = pet.value!.copyWith(name: name);
        Get.back();
        PawSnackbar.success('Nama berhasil diperbarui.');
      } else {
        dialogErrorMessage(result.message ?? 'Gagal memperbarui nama.');
      }
    } catch (e) {
      dialogErrorMessage('Gagal mengubah nama, coba lagi.');
    } finally {
      dialogIsLoading(false);
    }
  }

  Future<void> deletePet() async {
    final petName = pet.value?.name ?? 'Hewan';
    final confirmed = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error, size: 26),
              ),
              const SizedBox(height: 14),
              const Text(
                'Hapus Hewan?',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Hapus $petName? Semua riwayat analisis juga akan ikut terhapus dan tidak bisa dikembalikan.',
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(
                            color: Color(0xFFE0E0E0), width: 1.5),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                            color: AppColors.textMedium,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    dialogErrorMessage('');
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppColors.primary, size: 26),
              ),
              const SizedBox(height: 14),
              const Text(
                'Ubah Nama',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Masukkan nama baru untuk hewan peliharaanmu',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textMedium),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Nama hewan',
                  prefixIcon: const Icon(Icons.pets_rounded,
                      color: AppColors.primary, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFE8E8E8), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
              Obx(() {
                if (dialogErrorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dialogErrorMessage.value,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(
                            color: Color(0xFFE0E0E0), width: 1.5),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                            color: AppColors.textMedium,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: dialogIsLoading.value ? null : updateName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: dialogIsLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
