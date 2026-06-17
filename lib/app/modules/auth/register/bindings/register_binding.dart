import 'package:get/get.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepository());
    }
    Get.lazyPut<RegisterController>(
      () => RegisterController(repository: Get.find()),
    );
  }
}
