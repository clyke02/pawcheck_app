import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _authRepo = AuthRepository();
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final (u, _) = await _authRepo.loadSaved();
    user.value = u;
  }

  Future<void> logout() async {
    await _authRepo.logout();
    Get.offAllNamed(Routes.login);
  }
}
