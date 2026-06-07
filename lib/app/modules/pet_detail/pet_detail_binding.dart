import 'package:get/get.dart';
import '../../data/repositories/pet_repository.dart';
import 'pet_detail_controller.dart';

class PetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<PetDetailController>(
      () => PetDetailController(repository: Get.find()),
    );
  }
}
