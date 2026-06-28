import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../controllers/pets_controller.dart';

class PetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<PetsController>(
      () => PetsController(
        petRepository: Get.find(),
        authRepository: Get.find(),
      ),
    );
  }
}
