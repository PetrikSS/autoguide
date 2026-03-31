import 'dart:convert';

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

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'model': model,
    'generation': generation,
    'years': years,
    'imageUrl': imageUrl,
  };

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    brand: json['brand'],
    model: json['model'],
    generation: json['generation'],
    years: json['years'],
    imageUrl: json['imageUrl'],
  );
}