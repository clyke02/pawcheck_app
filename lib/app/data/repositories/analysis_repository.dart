import '../models/analysis_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/repository_helper.dart';

class AnalysisRepository with RepositoryHelper {
  Future<ApiResponse<List<AnalysisModel>>> getAnalyses() => guard(() async {
        final res = await ApiProvider.get('/analyses');
        final list = (res['data'] as List)
            .map((e) => AnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(list);
      });

  /// Analyze an existing pet using its current weight and activity level.
  /// Age, gender, neuter status and breed are taken from the pet on the server.
  Future<ApiResponse<AnalysisModel>> analyze({
    required int petId,
    required double weightKg,
    required String activityLevel,
  }) =>
      guard(() async {
        final res = await ApiProvider.post('/analyses', {
          'pet_id': petId,
          'weight_kg': weightKg,
          'activity_level': activityLevel,
        });
        return ApiResponse.success(
            AnalysisModel.fromJson(res['data'] as Map<String, dynamic>),
            message: res['message'] as String?);
      });

  Future<ApiResponse<bool>> deleteAnalysis(int id) => guard(() async {
        final res = await ApiProvider.delete('/analyses/$id');
        return ApiResponse.success(true, message: res['message'] as String?);
      });
}
