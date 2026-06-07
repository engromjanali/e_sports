
class LeaderboardPlayerModel {
  final String id;
  final String name;
  final String short;
  final String image;
  final List<String> tags;

  final int matches;
  final int wins;
  final int draws;
  final int losses;
  final int goals;
  final int pts;

  const LeaderboardPlayerModel({
    required this.id,
    required this.name,
    required this.short,
    required this.image,
    required this.tags,
    required this.matches,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goals,
    required this.pts,
  });
}

