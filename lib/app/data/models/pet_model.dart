import 'analysis_model.dart';
import 'breed_model.dart';

class PetModel {
  final int id;
  final int userId;
  final int breedId;
  final String name;
  final String gender;
  final String? imageUrl;
  final double? breedConfidence;
  final bool isNeutered;
  final String? birthDate;
  final double? ageAtRegistration;
  final double currentAgeYears;
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
    this.imageUrl,
    this.breedConfidence,
    this.isNeutered = false,
    this.birthDate,
    this.ageAtRegistration,
    this.currentAgeYears = 0.0,
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
        imageUrl: json['image_url'] as String?,
        breedConfidence:
            double.tryParse(json['breed_confidence']?.toString() ?? ''),
        isNeutered: json['is_neutered'] as bool? ?? false,
        birthDate: json['birth_date'] as String?,
        ageAtRegistration:
            double.tryParse(json['age_at_registration']?.toString() ?? ''),
        currentAgeYears:
            double.tryParse(json['current_age_years']?.toString() ?? '') ?? 0.0,
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
  String get neuterLabel => isNeutered ? 'Steril' : 'Belum Steril';

  String get currentAgeLabel {
    final totalMonths = (currentAgeYears * 12).round();
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;
    if (years <= 0) return '$months bulan';
    if (months == 0) return '$years tahun';
    return '$years tahun $months bulan';
  }

  AnalysisModel? get latestAnalysis =>
      (analyses != null && analyses!.isNotEmpty) ? analyses!.first : null;

  PetModel copyWith({String? name}) => PetModel(
        id: id,
        userId: userId,
        breedId: breedId,
        name: name ?? this.name,
        gender: gender,
        imageUrl: imageUrl,
        breedConfidence: breedConfidence,
        isNeutered: isNeutered,
        birthDate: birthDate,
        ageAtRegistration: ageAtRegistration,
        currentAgeYears: currentAgeYears,
        breed: breed,
        analyses: analyses,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
