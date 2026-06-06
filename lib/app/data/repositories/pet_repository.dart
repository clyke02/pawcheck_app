import '../models/pet_model.dart';
import '../providers/api_provider.dart';

class PetRepository {
  Future<List<PetModel>> getPets() async {
    final res = await ApiProvider.get('/pets');
    return (res['data'] as List).map((e) => PetModel.fromJson(e)).toList();
  }

  Future<PetModel> getPet(int id) async {
    final res = await ApiProvider.get('/pets/$id');
    return PetModel.fromJson(res['data']);
  }

  Future<PetModel> createPet(String name, int analysisId) async {
    final res = await ApiProvider.post('/pets', {
      'name': name,
      'analysis_id': analysisId,
    });
    return PetModel.fromJson(res['data']);
  }

  Future<PetModel> updatePet(int id, String name) async {
    final res = await ApiProvider.put('/pets/$id', {'name': name});
    return PetModel.fromJson(res['data']);
  }

  Future<void> deletePet(int id) async {
    await ApiProvider.delete('/pets/$id');
  }
}
