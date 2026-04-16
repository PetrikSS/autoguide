import 'dart:convert';

class Part {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final String location;
  final String priceRange;
  final List<String> symptoms;
  final List<String> tools;
  final String instructions;
  final String difficulty;
  final int estimatedTimeMin;
  final String? videoUrl;
  final List<String> oemNumbers;
  final String imageUrl;

  Part({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.location,
    required this.priceRange,
    required this.symptoms,
    required this.tools,
    required this.instructions,
    required this.difficulty,
    required this.estimatedTimeMin,
    this.videoUrl,
    required this.oemNumbers,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'categoryId': categoryId,
    'description': description,
    'location': location,
    'priceRange': priceRange,
    'symptoms': jsonEncode(symptoms),
    'tools': jsonEncode(tools),
    'instructions': instructions,
    'difficulty': difficulty,
    'estimatedTimeMin': estimatedTimeMin,
    'videoUrl': videoUrl,
    'oemNumbers': jsonEncode(oemNumbers),
    'imageUrl': imageUrl,
  };

  factory Part.fromJson(Map<String, dynamic> j) => Part(
    id: j['id'].toString(),
    name: j['name'],
    categoryId: j['categoryId'].toString(),
    description: j['description'],
    location: j['location'],
    priceRange: j['priceRange'],
    symptoms: List<String>.from(jsonDecode(j['symptoms'])),
    tools: List<String>.from(jsonDecode(j['tools'])),
    instructions: j['instructions'],
    difficulty: j['difficulty'],
    estimatedTimeMin: j['estimatedTimeMin'],
    videoUrl: j['videoUrl'],
    oemNumbers: List<String>.from(jsonDecode(j['oemNumbers'])),
    imageUrl: j['imageUrl'],
  );
}