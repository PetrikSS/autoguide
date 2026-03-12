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
  final String difficulty; // Легко, Средне, Сложно
  final int estimatedTimeMin; // Время в минутах
  final String? videoUrl; // Ссылка на видео
  final List<String> oemNumbers; // Оригинальные номера
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
}