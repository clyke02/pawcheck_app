import 'dart:io';
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

  Future<ApiResponse<AnalysisModel>> analyze({
    required File image,
    required String petName,
    required double weightKg,
    required double ageYears,
    required String gender,
  }) =>
      guard(() async {
        final res = await ApiProvider.postMultipart(
          '/analyses',
          {
            'pet_name': petName,
            'weight_kg': weightKg.toString(),
            'age_years': ageYears.toString(),
            'gender': gender,
          },
          image,
        );
        return ApiResponse.success(
            AnalysisModel.fromJson(res['data'] as Map<String, dynamic>),
            message: res['message'] as String?);
      });

  Future<ApiResponse<AnalysisModel>> reanalyze({
    required int petId,
    required double weightKg,
    required double ageYears,
  }) =>
      guard(() async {
        final res = await ApiProvider.post('/pets/$petId/analyses', {
          'weight_kg': weightKg,
          'age_years': ageYears,
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
