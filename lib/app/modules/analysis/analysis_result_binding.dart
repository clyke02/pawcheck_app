import 'package:get/get.dart';
import '../../data/repositories/pet_repository.dart';
import 'analysis_result_controller.dart';

class AnalysisResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetRepository>(() => PetRepository());
    Get.lazyPut<AnalysisResultController>(
      () => AnalysisResultController(petRepository: Get.find()),
    );
  }
}
