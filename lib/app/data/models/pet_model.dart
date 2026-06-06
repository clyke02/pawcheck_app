import 'analysis_model.dart';
import 'breed_model.dart';

class PetModel {
  final int id;
  final int userId;
  final int breedId;
  final String name;
  final String gender;
  final BreedModel? breed;
  final List<AnalysisModel> analyses;
  final DateTime createdAt;

  PetModel({
    required this.id,
    required this.userId,
    required this.breedId,
    required this.name,
    required this.gender,
    this.breed,
    this.analyses = const [],
    required this.createdAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        id: json['id'],
        userId: json['user_id'],
        breedId: json['breed_id'],
        name: json['name'],
        gender: json['gender'],
        breed: json['breed'] != null ? BreedModel.fromJson(json['breed']) : null,
        analyses: json['analyses'] != null
            ? (json['analyses'] as List).map((a) => AnalysisModel.fromJson(a)).toList()
            : [],
        createdAt: DateTime.parse(json['created_at']),
      );

  String get genderLabel => gender == 'male' ? 'Jantan' : 'Betina';
  String get genderEmoji => gender == 'male' ? '♂️' : '♀️';
  String get speciesEmoji => breed?.species == 'cat' ? '🐱' : '🐶';
}
