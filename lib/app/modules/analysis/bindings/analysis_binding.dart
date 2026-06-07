import 'package:get/get.dart';
import '../../../data/repositories/analysis_repository.dart';
import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisRepository>(() => AnalysisRepository());
    Get.lazyPut<AnalysisController>(
      () => AnalysisController(repository: Get.find()),
    );
  }
}
