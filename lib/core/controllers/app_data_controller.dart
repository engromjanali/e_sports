// import 'package:e_sports/core/data/models/computed_player_stats.dart';
// import 'package:e_sports/core/data/models/match_entry_model.dart';
// import 'package:e_sports/core/data/models/player_model.dart';
// import 'package:e_sports/core/data/models/news_model.dart';
// import 'package:e_sports/core/data/models/match_model.dart';
// import 'package:e_sports/core/data/models/tournament_model.dart';
// import 'package:e_sports/core/data/models/achievement_model.dart';
// import 'package:e_sports/core/services/filter_service.dart';
// import 'package:e_sports/core/services/mock_data_source.dart';
// import 'package:get/get.dart';

// class AppDataController extends GetxController {
//   final RxList<PlayerModel> players = <PlayerModel>[].obs;
//   final RxList<MatchEntryModel> matchEntries = <MatchEntryModel>[].obs;
  
//   final RxList<NewsModel> news = <NewsModel>[].obs;
//   final RxList<MatchModel> matches = <MatchModel>[].obs;
//   final RxList<TournamentModel> tournaments = <TournamentModel>[].obs;
//   final RxList<AchievementModel> achievements = <AchievementModel>[].obs;

//   final Rx<TimeFilter> currentFilter = TimeFilter.season.obs;
//   final Rx<DateTime> seasonStartDate = DateTime(DateTime.now().year, 1, 1).obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadData();
//   }

//   void _loadData() {
//     players.assignAll(MockDataSource.getPlayers());
//     matchEntries.assignAll(MockDataSource.getMatchEntries());
//     news.assignAll(MockDataSource.getNews());
//     tournaments.assignAll(MockDataSource.getTournaments());
//     achievements.assignAll(MockDataSource.getAchievements());
//     matches.assignAll(_getMockMatches());
//   }
import '../data/models/computed_player_stats.dart';
import '../data/models/match_entry_model.dart';
import '../data/models/player_model.dart';
import '../data/models/news_model.dart';
import '../data/models/match_model.dart';
import '../data/models/tournament_model.dart';
import '../domain/services/app_data_service_interface.dart';
import '../services/filter_service.dart';
import 'package:get/get.dart';

class AppDataController extends GetxController {
  final AppDataServiceInterface appDataServiceInterface;

  AppDataController({required this.appDataServiceInterface});

  final RxList<PlayerModel> players = <PlayerModel>[].obs;
  final RxList<MatchEntryModel> matchEntries = <MatchEntryModel>[].obs;
  final RxList<NewsModel> news = <NewsModel>[].obs;
  final RxList<MatchModel> matches = <MatchModel>[].obs;
  final RxList<TournamentModel> tournaments = <TournamentModel>[].obs;
  // ✅ achievements removed — now auto-computed via AchievementGenerator

  final Rx<TimeFilter> currentFilter = TimeFilter.season.obs;
  final Rx<DateTime> seasonStartDate = DateTime(DateTime.now().year, 1, 1).obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    players.assignAll(await appDataServiceInterface.getPlayers());
    matchEntries.assignAll(await appDataServiceInterface.getMatchEntries());
    news.assignAll(await appDataServiceInterface.getNews());
    tournaments.assignAll(await appDataServiceInterface.getTournaments());
    matches.assignAll(await appDataServiceInterface.getMatches());
  }

  // ... rest stays exactly the same
  // --- Actions ---
  
  Future<void> getPlayer()async{

  }


  void addMatchEntry(MatchEntryModel entry) {
    matchEntries.add(entry);
  }

  void setFilter(TimeFilter filter) {
    currentFilter.value = filter;
  }

  // --- Dynamic Computed State ---

  Map<String, num> get maxStats {
    final list = rankedPlayers;
    if (list.isEmpty) return {};
    
    num safeMax(Iterable<num> values) => values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);

    return {
      'matches': safeMax(list.map((p) => p.matches)),
      'wins': safeMax(list.map((p) => p.wins)),
      'losses': safeMax(list.map((p) => p.losses)),
      'draws': safeMax(list.map((p) => p.draws)),
      'goals': safeMax(list.map((p) => p.goals)),
      'hattricks': safeMax(list.map((p) => p.hattricks)),
      'cleansheets': safeMax(list.map((p) => p.cleansheets)),
      'motm': safeMax(list.map((p) => p.motm)),
      'pts': safeMax(list.map((p) => p.pts)),
      'ga': safeMax(list.map((p) => p.ga)),
      'fa': 1.0, 
    };
  }

  List<ComputedPlayerStats> get rankedPlayers {
    return FilterService.getRankedPlayers(
      filter: currentFilter.value,
      players: players.toList(),
      allEntries: matchEntries.toList(),
      seasonStartDate: seasonStartDate.value,
    );
  }

  List<ComputedPlayerStats> get weeklyPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.week, players: players.toList(), allEntries: matchEntries.toList(),
  );

  List<ComputedPlayerStats> get monthlyPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.month, players: players.toList(), allEntries: matchEntries.toList(),
  );

  List<ComputedPlayerStats> get seasonalPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.season, players: players.toList(), allEntries: matchEntries.toList(), seasonStartDate: seasonStartDate.value,
  );

  List<ComputedPlayerStats> get weeklyScorers => List.from(weeklyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get monthlyScorers => List.from(monthlyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get seasonalScorers => List.from(seasonalPlayers)..sort((a, b) => b.goals.compareTo(a.goals));

  ComputedPlayerStats? getPlayerStats(int playerId) {
    final player = players.firstWhereOrNull((p) => p.id == playerId);
    if (player == null) return null;
    return rankedPlayers.firstWhereOrNull((s) => s.player.id == playerId);
  }
}
