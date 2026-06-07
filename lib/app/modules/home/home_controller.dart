import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/pet_repository.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthRepository authRepository;
  final PetRepository petRepository;
  HomeController({required this.authRepository, required this.petRepository});

  final user = Rxn<UserModel>();
  final petsCount = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    loadPetsCount();
  }

  Future<void> _loadUser() async {
    try {
      isLoading(true);
      errorMessage('');
      final (u, _) = await authRepository.loadSaved();
      user.value = u;
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadPetsCount() async {
    try {
      final result = await petRepository.getPets();
      if (result.success) {
        petsCount.value = result.data?.length ?? 0;
      }
    } catch (_) {}
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      await authRepository.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
