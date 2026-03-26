class MatchModel {
  final String id;
  final String team1;
  final String team2;
  final String score1;
  final String score2;
  final String time;
  final String date;
  final String status; // 'live', 'upcoming', 'finished'
  final String tournament;

  final String? resultLabel;
  final String? resultType;
  final int? slots;

  MatchModel({
    required this.id,
    required this.team1,
    required this.team2,
    this.score1 = '0',
    this.score2 = '0',
    required this.time,
    required this.date,
    required this.status,
    required this.tournament,
    this.resultLabel,
    this.resultType,
    this.slots,
  });
}
