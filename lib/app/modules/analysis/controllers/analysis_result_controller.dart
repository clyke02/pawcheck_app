import 'package:get/get.dart';
import '../../../data/models/analysis_model.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/paw_snackbar.dart';

class AnalysisResultController extends GetxController {
  final PetRepository petRepository;
  AnalysisResultController({required this.petRepository});

  final analysis = Rxn<AnalysisModel>();
  final isSaving = false.obs;
  String _petName = '';
  int? _reanalysisPetId;

  bool get isReanalysis => _reanalysisPetId != null;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Map) {
      analysis.value = arg['analysis'] as AnalysisModel?;
      _petName = arg['petName'] as String? ?? '';
      _reanalysisPetId = arg['reanalysisPetId'] as int?;
    } else if (arg is AnalysisModel) {
      analysis.value = arg;
    }
  }

  Future<void> savePet() async {
    if (isSaving.value) return;
    final id = analysis.value?.id;
    if (id == null) return;
    try {
      isSaving(true);
      final result = await petRepository.createPet(_petName, id);
      if (result.success) {
        PawSnackbar.success('${result.data?.name ?? _petName} berhasil disimpan.');
        Get.offAllNamed(Routes.MAIN);
      } else {
        PawSnackbar.error(result.message ?? 'Gagal menyimpan hewan.');
      }
    } catch (e) {
      PawSnackbar.error('Gagal menyimpan hewan, mohon coba lagi.');
    } finally {
      isSaving(false);
    }
  }

  bool get isViewMode => analysis.value?.petId != null;

  void analisisLagi() {
    if (isViewMode) {
      Get.toNamed(Routes.ANALYSIS);
    } else {
      Get.back(); // analysis form masih di stack
    }
  }

  void done() {
    if (isReanalysis) {
      Get.until((route) => route.settings.name == Routes.PET_DETAIL);
    } else if (isViewMode) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.MAIN);
    }
  }
}
