class BreedModel {
  final int id;
  final String name;
  final String species;
  final double idealWeightMale;
  final double idealWeightFemale;

  BreedModel({
    required this.id,
    required this.name,
    required this.species,
    required this.idealWeightMale,
    required this.idealWeightFemale,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) => BreedModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        species: json['species'] as String? ?? '',
        idealWeightMale:
            double.tryParse(json['ideal_weight_male']?.toString() ?? '') ?? 0.0,
        idealWeightFemale:
            double.tryParse(json['ideal_weight_female']?.toString() ?? '') ?? 0.0,
      );

  String get speciesLabel => species == 'cat' ? 'Kucing' : 'Anjing';
}
