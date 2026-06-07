import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<HomeController>(
      () => HomeController(
        authRepository: Get.find(),
        petRepository: Get.find(),
      ),
    );
  }
}
