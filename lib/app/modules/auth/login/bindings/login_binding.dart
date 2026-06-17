import 'package:get/get.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepository());
    }
    Get.lazyPut<LoginController>(
      () => LoginController(repository: Get.find()),
    );
  }
}
