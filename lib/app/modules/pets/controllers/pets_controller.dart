import 'package:get/get.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/paw_snackbar.dart';

class PetsController extends GetxController {
  final PetRepository petRepository;
  final AuthRepository authRepository;
  PetsController({required this.petRepository, required this.authRepository});

  final pets = <PetModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    loadPets();
  }

  Future<void> _loadUser() async {
    try {
      final (u, _) = await authRepository.loadSaved();
      if (u != null) userName.value = u.name;
    } catch (_) {}
  }

  Future<void> loadPets() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await petRepository.getPets();
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
      final result = await petRepository.deletePet(id);
      if (result.success) {
        pets.removeWhere((p) => p.id == id);
        PawSnackbar.success('Hewan peliharaan berhasil dihapus.');
      } else {
        PawSnackbar.error(result.message ?? 'Gagal menghapus hewan.');
        loadPets();
      }
    } catch (e) {
      PawSnackbar.error('Gagal menghapus hewan, coba lagi.');
      loadPets();
    }
  }

  Future<void> goAddPet() async {
    await Get.toNamed(Routes.ADD_PET);
    loadPets();
  }

  Future<void> goDetail(PetModel pet) async {
    await Get.toNamed(Routes.PET_DETAIL, arguments: pet);
    loadPets();
  }

  Future<void> logout() async {
    await authRepository.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
