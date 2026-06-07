import 'analysis_model.dart';
import 'breed_model.dart';

class PetModel {
  final int id;
  final int userId;
  final int breedId;
  final String name;
  final String gender;
  final BreedModel? breed;
  final List<AnalysisModel>? analyses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PetModel({
    required this.id,
    required this.userId,
    required this.breedId,
    required this.name,
    required this.gender,
    this.breed,
    this.analyses,
    this.createdAt,
    this.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        id: json['id'] as int? ?? 0,
        userId: json['user_id'] as int? ?? 0,
        breedId: json['breed_id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        gender: json['gender'] as String? ?? 'male',
        breed: json['breed'] != null
            ? BreedModel.fromJson(json['breed'] as Map<String, dynamic>)
            : null,
        analyses: json['analyses'] != null
            ? (json['analyses'] as List)
                .map((a) => AnalysisModel.fromJson(a as Map<String, dynamic>))
                .toList()
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'] as String)
            : null,
      );

  String get genderLabel => gender == 'male' ? 'Jantan' : 'Betina';
  String get genderEmoji => gender == 'male' ? '♂️' : '♀️';
  String get speciesEmoji => breed?.species == 'cat' ? '🐱' : '🐶';
  String get speciesLabel => breed?.speciesLabel ?? 'Hewan';

  AnalysisModel? get latestAnalysis =>
      (analyses != null && analyses!.isNotEmpty) ? analyses!.first : null;
}
