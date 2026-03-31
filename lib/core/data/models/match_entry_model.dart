class MatchEntryModel {
  final String id;
  final int playerId;
  final DateTime date;
  final String result; // 'win', 'loss', 'draw'
  final int goals;
  final int goalsConceded;
  final bool hattrick;
  final bool cleanSheet;
  final bool motm;

  const MatchEntryModel({
    required this.id,
    required this.playerId,
    required this.date,
    required this.result,
    required this.goals,
    required this.goalsConceded,
    required this.hattrick,
    required this.cleanSheet,
    required this.motm,
  });
}
