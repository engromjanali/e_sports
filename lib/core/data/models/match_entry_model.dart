class MatchEntryModel {
  final String id;
  final String playerId;
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

  factory MatchEntryModel.fromJson(Map<String, dynamic> json) {
    final matchDate = (json['matches'] as Map<String, dynamic>?)?['date']?.toString()
        ?? json['created_at']?.toString()
        ?? '';
    return MatchEntryModel(
      id: json['id']?.toString() ?? '',
      playerId: json['playerid']?.toString() ?? '',
      date: DateTime.tryParse(matchDate) ?? DateTime(2000),
      result: json['result']?.toString() ?? 'draw',
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      goalsConceded: (json['goalsconceded'] as num?)?.toInt() ?? 0,
      hattrick: ((json['hattricks'] as num?)?.toInt() ?? 0) > 0,
      cleanSheet: json['cleansheet'] as bool? ?? false,
      motm: json['motm'] as bool? ?? false,
    );
  }
}
