import 'package:get/get.dart';
import '../../../data/repositories/pet_repository.dart';
import '../controllers/pets_controller.dart';

class PetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<PetsController>(
      () => PetsController(repository: Get.find()),
    );
  }
}
