class Car {
  final String brand;
  final String model;
  final String generation;
  final String years;
  final String? imageUrl;

  Car({
    required this.brand,
    required this.model,
    required this.generation,
    required this.years,
    this.imageUrl,
  });

  String get fullName => '$brand $model';
  String get fullInfo => '$brand $model ($generation) $years';
}