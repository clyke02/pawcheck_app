import 'package:get/get.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../widgets/paw_snackbar.dart';

class PetsController extends GetxController {
  final PetRepository repository;
  PetsController({required this.repository});

  final pets = <PetModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.getPets();
      if (result.success) {
        pets.value = result.data ?? [];
      } else {
        errorMessage(result.message ?? 'Gagal memuat data.');
      }
    } catch (e) {
      errorMessage('Gagal memuat daftar hewan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePet(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.deletePet(id);
      if (result.success) {
        pets.removeWhere((p) => p.id == id);
        PawSnackbar.success('Hewan peliharaan berhasil dihapus.');
      } else {
        errorMessage(result.message ?? 'Gagal menghapus hewan.');
      }
    } catch (e) {
      errorMessage('Gagal menghapus hewan, coba lagi.');
    } finally {
      isLoading(false);
    }
  }
}
