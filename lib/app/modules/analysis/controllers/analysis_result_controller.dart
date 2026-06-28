import 'package:get/get.dart';
import '../../../data/models/analysis_model.dart';
import '../../../routes/app_pages.dart';

class AnalysisResultController extends GetxController {
  final analysis = Rxn<AnalysisModel>();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Map) {
      analysis.value = arg['analysis'] as AnalysisModel?;
    } else if (arg is AnalysisModel) {
      analysis.value = arg;
    }
  }

  /// The analysis is already saved to the pet; finishing returns to the
  /// pet detail page (which reloads its history).
  void done() {
    Get.until((route) => route.settings.name == Routes.PET_DETAIL);
  }
}
