import '../models/pet_model.dart';
import '../providers/api_provider.dart';
import '../../../core/utils/api_response.dart';

class PetRepository {
  Future<ApiResponse<List<PetModel>>> getPets() async {
    try {
      final res = await ApiProvider.get('/pets');
      final list = (res['data'] as List)
          .map((e) => PetModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(list);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<PetModel>> getPet(int id) async {
    try {
      final res = await ApiProvider.get('/pets/$id');
      return ApiResponse.success(
          PetModel.fromJson(res['data'] as Map<String, dynamic>));
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<PetModel>> createPet(String name, int analysisId) async {
    try {
      final res = await ApiProvider.post('/pets', {
        'name': name,
        'analysis_id': analysisId,
      });
      return ApiResponse.success(
          PetModel.fromJson(res['data'] as Map<String, dynamic>),
          message: res['message'] as String?);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<PetModel>> updatePet(int id, String name) async {
    try {
      final res = await ApiProvider.put('/pets/$id', {'name': name});
      return ApiResponse.success(
          PetModel.fromJson(res['data'] as Map<String, dynamic>),
          message: res['message'] as String?);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> deletePet(int id) async {
    try {
      final res = await ApiProvider.delete('/pets/$id');
      return ApiResponse.success(true, message: res['message'] as String?);
    } on ApiException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
