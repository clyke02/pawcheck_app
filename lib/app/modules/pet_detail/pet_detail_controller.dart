import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

class PetDetailController extends GetxController {
  final _repo = PetRepository();
  final pet = Rxn<PetModel>();
  final isLoading = false.obs;
  final nameCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is PetModel) {
      pet.value = arg;
      nameCtrl.text = arg.name;
      _refresh(arg.id);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }

  Future<void> _refresh(int id) async {
    isLoading.value = true;
    try {
      pet.value = await _repo.getPet(id);
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> updateName() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty || name == pet.value?.name) {
      Get.back();
      return;
    }
    try {
      final updated = await _repo.updatePet(pet.value!.id, name);
      pet.value = updated;
      Get.back();
      Get.snackbar('Berhasil', 'Nama diperbarui.',
          backgroundColor: Colors.green[100]);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[100]);
    }
  }

  void showEditNameDialog() {
    nameCtrl.text = pet.value?.name ?? '';
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama hewan'),
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
