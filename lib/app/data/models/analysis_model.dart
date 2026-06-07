import 'pet_model.dart';

class AnalysisModel {
  final int id;
  final int? petId;
  final String imageUrl;
  final double weightKg;
  final double ageYears;
  final String gender;
  final String breedPrediction;
  final double confidenceScore;
  final double idealWeightUsed;
  final int bcsScore;
  final String bcsCategory;
  final double rer;
  final double mer;
  final String? nutritionRecommendation;
  final DateTime createdAt;
  final PetModel? pet;

  AnalysisModel({
    required this.id,
    this.petId,
    required this.imageUrl,
    required this.weightKg,
    required this.ageYears,
    required this.gender,
    required this.breedPrediction,
    required this.confidenceScore,
    required this.idealWeightUsed,
    required this.bcsScore,
    required this.bcsCategory,
    required this.rer,
    required this.mer,
    this.nutritionRecommendation,
    required this.createdAt,
    this.pet,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) => AnalysisModel(
        id: json['id'] as int? ?? 0,
        petId: json['pet_id'] as int?,
        imageUrl: json['image_url'] as String? ?? '',
        weightKg:
            double.tryParse(json['weight_kg']?.toString() ?? '') ?? 0.0,
        ageYears:
            double.tryParse(json['age_years']?.toString() ?? '') ?? 0.0,
        gender: json['gender'] as String? ?? 'male',
        breedPrediction: json['breed_prediction'] as String? ?? '',
        confidenceScore:
            double.tryParse(json['confidence_score']?.toString() ?? '') ?? 0.0,
        idealWeightUsed:
            double.tryParse(json['ideal_weight_used']?.toString() ?? '') ?? 0.0,
        bcsScore: json['bcs_score'] as int? ?? 3,
        bcsCategory: json['bcs_category'] as String? ?? '',
        rer: double.tryParse(json['rer']?.toString() ?? '') ?? 0.0,
        mer: double.tryParse(json['mer']?.toString() ?? '') ?? 0.0,
        nutritionRecommendation: json['nutrition_recommendation'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
            : DateTime.now(),
        pet: json['pet'] != null
            ? PetModel.fromJson(json['pet'] as Map<String, dynamic>)
            : null,
      );

  String get bcsEmoji {
    switch (bcsScore) {
      case 1: return '😟';
      case 2: return '😕';
      case 3: return '😊';
      case 4: return '😅';
      case 5: return '😰';
      default: return '❓';
    }
  }

  String get confidencePercent =>
      '${(confidenceScore * 100).toStringAsFixed(1)}%';

  String get genderLabel => gender == 'male' ? 'Jantan' : 'Betina';

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()} tahun lalu';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()} bulan lalu';
    if (diff.inDays >= 1) return '${diff.inDays} hari lalu';
    if (diff.inHours >= 1) return '${diff.inHours} jam lalu';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }
}
