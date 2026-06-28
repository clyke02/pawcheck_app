import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/paw_snackbar.dart';

class PetFormController extends GetxController {
  final PetRepository repository;
  PetFormController({required this.repository});

  final _picker = ImagePicker();

  final nameCtrl = TextEditingController();
  final selectedImage = Rxn<File>();
  final selectedGender = 'male'.obs;
  final isNeutered = false.obs;

  // Age input: 'estimate' (Tahun + Bulan) or 'birthdate' (date picker).
  final ageMode = 'estimate'.obs;
  final yearCtrl = TextEditingController();
  final monthCtrl = TextEditingController();
  final birthDate = Rxn<DateTime>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    nameCtrl.dispose();
    yearCtrl.dispose();
    monthCtrl.dispose();
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
      errorMessage('Gagal membuka foto, coba lagi.');
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Galeri'),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Future<void> pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: birthDate.value ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) birthDate.value = picked;
  }

  String get birthDateLabel {
    final d = birthDate.value;
    if (d == null) return 'Pilih tanggal lahir';
    return '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  Future<void> submit() async {
    errorMessage('');
    if (nameCtrl.text.trim().isEmpty) {
      errorMessage('Nama hewan wajib diisi.');
      return;
    }
    if (selectedImage.value == null) {
      errorMessage('Foto hewan wajib diunggah.');
      return;
    }

    String? birthDateStr;
    double? ageAtReg;
    if (ageMode.value == 'birthdate') {
      final d = birthDate.value;
      if (d == null) {
        errorMessage('Pilih tanggal lahir hewan.');
        return;
      }
      birthDateStr = '${d.year}-${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
    } else {
      final years = int.tryParse(yearCtrl.text.trim()) ?? 0;
      final months = int.tryParse(monthCtrl.text.trim()) ?? 0;
      if (years <= 0 && months <= 0) {
        errorMessage('Masukkan perkiraan umur hewan.');
        return;
      }
      ageAtReg = years + months / 12;
    }

    try {
      isLoading(true);
      final result = await repository.createPet(
        name: nameCtrl.text.trim(),
        image: selectedImage.value!,
        gender: selectedGender.value,
        isNeutered: isNeutered.value,
        birthDate: birthDateStr,
        ageAtRegistration: ageAtReg,
      );
      if (result.success && result.data != null) {
        PawSnackbar.success(result.message ?? 'Hewan berhasil ditambahkan.');
        // Replace the form with the new pet's detail page.
        Get.offNamed(Routes.PET_DETAIL, arguments: result.data);
      } else {
        errorMessage(result.message ?? 'Gagal menambahkan hewan.');
      }
    } catch (e) {
      errorMessage('Gagal menambahkan hewan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }
}
