import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../pets/controllers/pets_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent singletons — shared across all child routes
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<PetRepository>(PetRepository(), permanent: true);

    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        authRepository: Get.find(),
        petRepository: Get.find(),
      ),
    );
    Get.lazyPut<PetsController>(
      () => PetsController(
        petRepository: Get.find(),
        authRepository: Get.find(),
      ),
    );
  }
}
