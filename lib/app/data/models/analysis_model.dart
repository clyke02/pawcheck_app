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
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) => AnalysisModel(
        id: json['id'],
        petId: json['pet_id'],
        imageUrl: json['image_url'],
        weightKg: double.parse(json['weight_kg'].toString()),
        ageYears: double.parse(json['age_years'].toString()),
        gender: json['gender'],
        breedPrediction: json['breed_prediction'],
        confidenceScore: double.parse(json['confidence_score'].toString()),
        idealWeightUsed: double.parse(json['ideal_weight_used'].toString()),
        bcsScore: json['bcs_score'],
        bcsCategory: json['bcs_category'],
        rer: double.parse(json['rer'].toString()),
        mer: double.parse(json['mer'].toString()),
        nutritionRecommendation: json['nutrition_recommendation'],
        createdAt: DateTime.parse(json['created_at']),
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
}
