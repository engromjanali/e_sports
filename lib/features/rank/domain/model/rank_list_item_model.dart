/// Lightweight display model for the rank list rows (MiniPlayerCard).
/// Shared by the weekly / monthly / season-standings list endpoints.
class RankListItemModel {
  final String id;
  final String name;
  final String short;
  final String image;
  final int rank;
  final int pts;
  final int goals;
  final int matches;

  const RankListItemModel({
    required this.id,
    required this.name,
    required this.short,
    required this.image,
    required this.rank,
    required this.pts,
    required this.goals,
    required this.matches,
  });

  factory RankListItemModel.fromJson(Map<String, dynamic> json) {
    return RankListItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      short: json['short']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      pts: (json['pts'] as num?)?.toInt() ?? 0,
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
    );
  }
}
