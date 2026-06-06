import 'dart:io';
import '../models/analysis_model.dart';
import '../providers/api_provider.dart';

class AnalysisRepository {
  Future<List<AnalysisModel>> getAnalyses() async {
    final res = await ApiProvider.get('/analyses');
    return (res['data'] as List).map((e) => AnalysisModel.fromJson(e)).toList();
  }

  Future<AnalysisModel> analyze({
    required File image,
    required double weightKg,
    required double ageYears,
    required String gender,
  }) async {
    final res = await ApiProvider.postMultipart(
      '/analyses',
      {
        'weight_kg': weightKg.toString(),
        'age_years': ageYears.toString(),
        'gender': gender,
      },
      image,
    );
    return AnalysisModel.fromJson(res['data']);
  }

  Future<void> deleteAnalysis(int id) async {
    await ApiProvider.delete('/analyses/$id');
  }
}
