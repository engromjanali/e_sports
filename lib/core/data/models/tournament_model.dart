class TournamentModel {
  final int id;
  final String name;
  final String status;
  final String tag;
  final String prize;
  final String sponsor;
  final String starts;
  final String regDeadline;
  final String format;
  final int cost;
  final int slots;
  final int filled;
  final List<String> rounds;
  final List<TournamentReward> rewards;
  final List<TournamentBracketRound> bracket;

  const TournamentModel({
    required this.id,
    required this.name,
    required this.status,
    required this.tag,
    required this.prize,
    required this.sponsor,
    required this.starts,
    required this.regDeadline,
    required this.format,
    required this.cost,
    required this.slots,
    required this.filled,
    required this.rounds,
    required this.rewards,
    required this.bracket,
  });
}

class TournamentReward {
  final String icon, pos, detail;
  final dynamic color;
  TournamentReward({required this.icon, required this.pos, required this.detail, required this.color});
}

class TournamentBracketRound {
  final String roundName;
  final List<List<String>> matches;
  TournamentBracketRound({required this.roundName, required this.matches});
}
