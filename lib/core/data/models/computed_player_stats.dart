import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';

class ComputedPlayerStats {
  final PlayerModel player;
  final int pts;
  final int goals;
  final int matches;
  final int wins;
  final int losses;
  final int draws;
  final int gf;
  final int ga;
  final int rank;
  final double fa;
  final int hattricks;
  final int cleansheets;
  final int motm;
  final List<String> last20;
  final List<MatchEntryModel> matchHistory;

  // Additional stats for the UI
  final int assists;
  final int shotsOnTarget;
  final int passAccuracy;
  final int tackles;
  final int dribbles;
  final int stamina;

  ComputedPlayerStats({
    required this.player,
    this.pts = 0,
    this.goals = 0,
    this.matches = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.gf = 0,
    this.ga = 0,
    this.rank = 0,
    this.fa = 0.0,
    this.hattricks = 0,
    this.cleansheets = 0,
    this.motm = 0,
    this.last20 = const [],
    this.matchHistory = const [],
    // Provide hardcoded visual defaults or calculate them
    this.assists = 0,
    this.shotsOnTarget = 0,
    this.passAccuracy = 85,
    this.tackles = 0,
    this.dribbles = 0,
    this.stamina = 85,
  });

  // Proxy getters for ease of access in the UI
  int get id => player.id;
  String get name => player.name;
  String get short => player.short;
  String get team => player.team;
  int get jerseyNumber => player.jerseyNumber;
  List<String> get tags => player.tags;
}
