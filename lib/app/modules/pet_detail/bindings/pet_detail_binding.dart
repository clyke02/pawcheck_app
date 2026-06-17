import 'package:get/get.dart';
import '../controllers/pet_detail_controller.dart';

class PetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetDetailController>(
      () => PetDetailController(repository: Get.find()),
    );
  }
}
