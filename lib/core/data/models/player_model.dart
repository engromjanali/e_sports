class PlayerModel {
  final int id;
  final String name;
  final String short;
  final String team;
  final int jerseyNumber;
  final List<String> tags;
  final String imageUrl;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.short,
    required this.team,
    required this.jerseyNumber,
    required this.tags,
    this.imageUrl = '',
  });
}
