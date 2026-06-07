import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _authRepo = AuthRepository();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      isLoading(true);
      errorMessage('');
      final (u, _) = await _authRepo.loadSaved();
      user.value = u;
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      await _authRepo.logout();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
