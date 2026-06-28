import 'package:get/get.dart';
import '../../../data/repositories/pet_repository.dart';
import '../controllers/pet_form_controller.dart';

class PetFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<PetFormController>(
      () => PetFormController(repository: Get.find()),
    );
  }
}
