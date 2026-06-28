import 'dart:io';
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

  /// Create a pet: uploads the photo (for breed prediction) along with the
  /// pet's fixed attributes. Provide either [birthDate] (yyyy-MM-dd) or
  /// [ageAtRegistration] (in years).
  Future<ApiResponse<PetModel>> createPet({
    required String name,
    required File image,
    required String gender,
    required bool isNeutered,
    String? birthDate,
    double? ageAtRegistration,
  }) =>
      guard(() async {
        final fields = <String, String>{
          'name': name,
          'gender': gender,
          'is_neutered': isNeutered ? '1' : '0',
        };
        if (birthDate != null) fields['birth_date'] = birthDate;
        if (ageAtRegistration != null) {
          fields['age_at_registration'] = ageAtRegistration.toString();
        }
        final res = await ApiProvider.postMultipart('/pets', fields, image);
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
