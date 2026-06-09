class SeasonModel {
  final int id;
  final String name;
  final bool isCurrent;

  const SeasonModel({
    required this.id,
    required this.name,
    this.isCurrent = false,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }
}
