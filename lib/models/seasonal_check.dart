class SeasonalCheck {
  final int id;
  final String name;
  final String season;
  final int? checkIndex;
  final String? description;
  final String? optimalMonths;
  final String? priceRange;
  final List<String> symptoms;
  final String? note;
  final List<String> tools;
  final String? instruction;
  final String? difficulty;
  final int? estimatedTimeMin;
  final String? videoUrl;
  final String? imageUrl;

  SeasonalCheck({
    required this.id,
    required this.name,
    required this.season,
    this.checkIndex,
    this.description,
    this.optimalMonths,
    this.priceRange,
    required this.symptoms,
    this.note,
    required this.tools,
    this.instruction,
    this.difficulty,
    this.estimatedTimeMin,
    this.videoUrl,
    this.imageUrl,
  });
}
