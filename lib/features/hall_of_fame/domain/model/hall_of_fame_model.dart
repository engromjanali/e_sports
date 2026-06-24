// Server-driven Hall of Fame data. The whole screen comes from one payload:
// a list of award categories, each carrying its card metadata and the
// season-by-season entries below it.

class HofEntryModel {
  final String id;
  final String season;
  final String name; // inducted player's name (from the linked player)
  final String team;
  final String detail;
  final String image; // inducted player's photo

  const HofEntryModel({
    required this.id,
    required this.season,
    required this.name,
    required this.team,
    required this.detail,
    this.image = '',
  });

  factory HofEntryModel.fromJson(Map<String, dynamic> json) {
    return HofEntryModel(
      id: json['id']?.toString() ?? '',
      season: json['season']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      team: json['team']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class HofCategoryModel {
  final String key;
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final String accent; // named accent ('neonGold' | 'neonOrange' | 'neonCyan')
  final List<HofEntryModel> entries;

  const HofCategoryModel({
    required this.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.accent,
    required this.entries,
  });

  factory HofCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawEntries = json['entries'];
    return HofCategoryModel(
      key: json['key']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      badge: json['badge']?.toString() ?? '',
      accent: json['accent']?.toString() ?? 'neonGold',
      entries: rawEntries is List
          ? rawEntries
              .map((e) => HofEntryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
