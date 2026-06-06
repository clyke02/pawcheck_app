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
        id: json['id'],
        name: json['name'],
        species: json['species'],
        idealWeightMale: double.parse(json['ideal_weight_male'].toString()),
        idealWeightFemale: double.parse(json['ideal_weight_female'].toString()),
      );
}
