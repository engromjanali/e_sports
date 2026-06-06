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
    return MatchEntryModel(
      id: json['id']?.toString() ?? '',
      playerId: json['playerId']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      result: json['result']?.toString() ?? 'draw',
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      goalsConceded: (json['goalsConceded'] as num?)?.toInt() ?? 0,
      hattrick: ((json['hattricks'] as num?)?.toInt() ?? 0) > 0,
      cleanSheet: json['cleanSheet'] == true,
      motm: json['motm'] == true,
    );
  }
}
