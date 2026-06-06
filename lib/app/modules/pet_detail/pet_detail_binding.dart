import 'package:get/get.dart';
import 'pet_detail_controller.dart';

class PetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetDetailController>(() => PetDetailController());
  }
}
