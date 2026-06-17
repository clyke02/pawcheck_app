import '../models/pet_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/repository_helper.dart';

class PetRepository with RepositoryHelper {
  Future<ApiResponse<List<PetModel>>> getPets() => guard(() async {
        final res = await ApiProvider.get('/pets');
        final list = (res['data'] as List)
            .map((e) => PetModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(list);
      });

  Future<ApiResponse<PetModel>> getPet(int id) => guard(() async {
        final res = await ApiProvider.get('/pets/$id');
        return ApiResponse.success(
            PetModel.fromJson(res['data'] as Map<String, dynamic>));
      });

  Future<ApiResponse<PetModel>> createPet(String name, int analysisId) =>
      guard(() async {
        final res = await ApiProvider.post('/pets', {
          'name': name,
          'analysis_id': analysisId,
        });
        return ApiResponse.success(
            PetModel.fromJson(res['data'] as Map<String, dynamic>),
            message: res['message'] as String?);
      });

  Future<ApiResponse<PetModel>> updatePet(int id, String name) =>
      guard(() async {
        final res = await ApiProvider.put('/pets/$id', {'name': name});
        return ApiResponse.success(
            PetModel.fromJson(res['data'] as Map<String, dynamic>),
            message: res['message'] as String?);
      });

  Future<ApiResponse<bool>> deletePet(int id) => guard(() async {
        final res = await ApiProvider.delete('/pets/$id');
        return ApiResponse.success(true, message: res['message'] as String?);
      });
}
