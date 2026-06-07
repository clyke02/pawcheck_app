import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/pet_repository.dart';
import '../home/home_controller.dart';
import '../pets/pets_controller.dart';
import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        authRepository: Get.find(),
        petRepository: Get.find(),
      ),
    );
    Get.lazyPut<PetsController>(
      () => PetsController(repository: Get.find()),
    );
  }
}
