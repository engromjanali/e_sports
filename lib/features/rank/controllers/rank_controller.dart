import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:get/get.dart';

class RankController extends GetxController {
  final RankServiceInterface rankServiceInterface;

  RankController({required this.rankServiceInterface});

  // Tab index: 0 = Players, 1 = Scorers
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  void setTabIndex(int index) => _tabIndex.value = index;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  PlayerOfTheWeekAndMonthModel? _playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? get playerOfTheWeekAndMonthModel => _playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? _scorerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? get socrerOfTheWeekAndMonthModel => _scorerOfTheWeekAndMonthModel;
  List<LeaderboardPlayerModel> _overAllTopThreePlayer  = [];
  List<LeaderboardPlayerModel> get overAllTopThreePlayer => _overAllTopThreePlayer;
  List<LeaderboardPlayerModel> _seasonalTopThreePlayer = [];
  List<LeaderboardPlayerModel> get seasonalTopThreePlayer => _seasonalTopThreePlayer;
  List<LeaderboardPlayerModel> _overAllTopThreeScorer  = [];
  List<LeaderboardPlayerModel> get overAllTopThreeScorer => _overAllTopThreeScorer;
  List<LeaderboardPlayerModel> _seasonalTopThreeScorer = [];
  List<LeaderboardPlayerModel> get seasonalTopThreeScorer => _seasonalTopThreeScorer;



  final _selectedSeason = 'overall'.obs;
  String get selectedSeason => _selectedSeason.value;
  void setSelectedSeason(String val) {
    _selectedSeason.value = val.toLowerCase();
    update();
  }

  List<ComputedPlayerStats> get activePlayers => selectedSeason == 'overall'
      ? _toStatsList(_overAllTopThreePlayer)
      : _toStatsList(_seasonalTopThreePlayer);

  List<ComputedPlayerStats> get activeScorers => selectedSeason == 'overall'
      ? _toStatsList(_overAllTopThreeScorer)
      : _toStatsList(_seasonalTopThreeScorer);

  ComputedPlayerStats? get potWeek => _playerOfTheWeekAndMonthModel?.weekModel != null ? _weekModelToStats(_playerOfTheWeekAndMonthModel!.weekModel, 1)  : null;

  ComputedPlayerStats? get potMonth => _playerOfTheWeekAndMonthModel?.monthModel != null
      ? _weekModelToStats(_playerOfTheWeekAndMonthModel!.monthModel, 1)
      : null;

  ComputedPlayerStats? get potSeason => activePlayers.isNotEmpty ? activePlayers.first : null;

  // Scorer highlight cards map to the same award entry (scorer stats shown via isScorer flag).
  ComputedPlayerStats? get sotWeek  => potWeek;
  ComputedPlayerStats? get sotMonth => potMonth;
  ComputedPlayerStats? get sotSeason => activeScorers.isNotEmpty ? activeScorers.first : null;

  // ── List sections fed to RankingViewWidget ────────────────────────────────

  // Weekly / monthly sections show the single award winner as a list entry.
  List<ComputedPlayerStats> get weeklyPlayers  => potWeek  != null ? [potWeek!]  : [];
  List<ComputedPlayerStats> get monthlyPlayers => potMonth != null ? [potMonth!] : [];
  List<ComputedPlayerStats> get seasonalPlayers => activePlayers;

  List<ComputedPlayerStats> get weeklyScorers  => sotWeek  != null ? [sotWeek!]  : [];
  List<ComputedPlayerStats> get monthlyScorers => sotMonth != null ? [sotMonth!] : [];
  List<ComputedPlayerStats> get seasonalScorers => activeScorers;

  // Fallback used by PremiumHeroCard when the highlight slot is null.
  List<ComputedPlayerStats> get rankedPlayers => activePlayers;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    _isLoading = true;
    update();
    await Future.wait([
      getPlayerOfTheWeekAndMonth(),
      getScorerOfTheWeekAndMonth(),
      getOverAllTopThreePlayer(),
      getSeasonalTopThreePlayer(),
      getOverAllTopThreeScorer(),
      getSeasonalTopThreeScorer(),
    ]);
    _isLoading = false;
    update();
  }

  // ── Public fetch methods ──────────────────────────────────────────────────

  Future<void> getPlayerOfTheWeekAndMonth() async {
    _playerOfTheWeekAndMonthModel = await rankServiceInterface.getPlayerOfTheWeekAndMonth();
    update();
  }

  Future<void> getScorerOfTheWeekAndMonth() async {
    _playerOfTheWeekAndMonthModel = await rankServiceInterface.getPlayerOfTheWeekAndMonth();
    update();
  }

  Future<void> getOverAllTopThreePlayer() async {
    _overAllTopThreePlayer = await rankServiceInterface.getOverAllTopThreePlayer();
    update();
  }

  Future<void> getSeasonalTopThreePlayer() async {
    _seasonalTopThreePlayer = await rankServiceInterface.getSeasonalTopThreePlayer();
    update();
  }

  Future<void> getOverAllTopThreeScorer() async {
    _overAllTopThreeScorer = await rankServiceInterface.getOverAllTopThreeScorer();
    update();
  }

  Future<void> getSeasonalTopThreeScorer() async {
    _seasonalTopThreeScorer = await rankServiceInterface.getSeasonalTopThreeScorer();
    update();
  }

  String get tabLabel => _tabIndex.value == 0 ? "Players" : "Scorers";

  // ── Adapters: backend models → ComputedPlayerStats ────────────────────────

  List<ComputedPlayerStats> _toStatsList(List<LeaderboardPlayerModel> list) {
    return list.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final m    = entry.value;
      return ComputedPlayerStats(
        player: PlayerModel(
          id: m.id,
          name: m.name,
          sortName: m.short,
          jerseyNumber: 0,
          playerRoles: m.tags,
          imageUrl: m.image,
        ),
        goals:   m.goals,
        wins:    m.wins,
        draws:   m.draws,
        losses:  m.losses,
        matches: m.matches,
        pts:     m.pts,
        rank:    rank,
      );
    }).toList();
  }

  ComputedPlayerStats _weekModelToStats(PlayerOfTheWeeKModel m, int rank) {
    return ComputedPlayerStats(
      player: PlayerModel(
        id: m.id,
        name: m.name,
        sortName: m.short,
        jerseyNumber: 0,
        playerRoles: m.tags,
        imageUrl: m.image,
      ),
      goals:   m.goals,
      wins:    m.wins,
      matches: m.matches,
      pts:     m.pts,
      rank:    rank,
    );
  }
}
