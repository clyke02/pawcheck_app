import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import 'register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<RegisterController>(
      () => RegisterController(repository: Get.find()),
    );
  }
}
