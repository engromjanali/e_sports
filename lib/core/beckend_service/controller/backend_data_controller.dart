import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/enums/match_filter.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class BackendDataController extends GetxService{

  final SupabaseClient supabase;

  BackendDataController({required this.supabase});

  String endPointExtractor(String url) {
    return Uri.parse(url).path;
  }

/// methods

  // get
  Future<dynamic> getData(String endpoint, {dynamic payload1, required int season, int? limit, int? offset})async{
    switch (endpoint){
      case AppConstants.configUri:
        return fetchConfig();

      case AppConstants.homeMatch:
        return fetchMatchHome(season: season, limit: limit ?? 3);

      case AppConstants.matches:
        return fetchMatch(type: payload1 ?? MatchFilter.all, season: season, limit: limit ?? 10, offset: offset ?? 0);

      case AppConstants.news:
        return fetchNews();

      case AppConstants.players:
        return fetchPlayers();

      case AppConstants.matchEntries:
        return fetchMatchEntries();

      case AppConstants.playerOfTheWeekAndMonth:
        return fetchPlayerOfTheWeekAndMonth();

      case AppConstants.scorerOfTheWeekAndMonth:
        return fetchScorerOfTheWeekAndMonth();

      case AppConstants.overAllTopThreePlayer:
        return fetchOverAllTopThreePlayer();

      case AppConstants.seasonalTopThreePlayer:
        return fetchSeasonalTopThreePlayer(season: season);

      case AppConstants.overAllTopThreeScorer:
        return fetchOverAllTopThreeScorer();

      case AppConstants.seasonalTopThreeScorer:
        return fetchSeasonalTopThreeScorer(season: season);

      default:
        throw "end-point not found";

    }
  }

  // post
    Future<dynamic> postData(String endpoint, {dynamic payload1, required int season, int? limit, int? offset})async{
    switch (endpoint){
      case AppConstants.homeMatch:
        return fetchMatchHome(season: season, limit: limit ?? 3);

      case AppConstants.matches:
        return fetchMatch(type: payload1 ?? MatchFilter.all, season: season, limit: limit ?? 10, offset: offset ?? 0);

      default:
        throw "end-point not found";

    }
  }

/// ==================== config ========================

  Future<ConfigModel> fetchConfig() async {
    final settings = await supabase.from('app_settings').select().single();
    final seasonRows = await supabase
        .from('season')
        .select('id, name, is_current')
        .order('id', ascending: true);

    final merged = {
      'version':          settings['version'],
      'verify_email':     settings['verify_email'],
      'maintenance_mode': settings['maintenance_mode'],
      'current_season':   settings['current_season_id'],
      'seasons':          seasonRows,
    };

    printer("GET ${AppConstants.configUri}: $merged");
    return ConfigModel.fromJson(merged);
  }

/// ==================== match ========================

  Future<List<MatchModel>> fetchMatchHome({required int season, required int limit}) async {
    // Live matches take priority on the home screen (most recent first).
    final liveMatches = await supabase
        .from('matches')
        .select()
        .eq('season_id', season)
        .eq('status', MatchFilter.live.name)
        .order('date', ascending: false)
        .limit(limit);

    final List<dynamic> result = [...liveMatches];

    // Fill any remaining slots with the soonest upcoming fixtures.
    final remaining = limit - result.length;

    if (remaining > 0) {
      final upcomingMatches = await supabase
          .from('matches')
          .select()
          .eq('season_id', season)
          .eq('status', MatchFilter.upcoming.name)
          .order('date', ascending: true)
          .limit(remaining);

      result.addAll(upcomingMatches);
    }

    printer("GET ${AppConstants.homeMatch}: $result");
    return result.map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MatchModel>> fetchMatch({required MatchFilter type, required int season, required int limit, required int offset}) async {
    var query = supabase.from('matches').select().eq('season_id', season);

    if (type != MatchFilter.all) {
      query = query.eq('status', type.name);
    }

    // Page is 0-based; translate to an inclusive row range for the server.
    final data = await query.range(
      offset * limit,
      offset * limit + limit - 1,
    );

    printer("GET ${AppConstants.matches}: $data");

    return (data as List).map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }
    
/// ===================== news ===========================

  Future<List<NewsModel>> fetchNews({int? limit, int? offset, String? search}) async {
    var filter = supabase.from('news').select();

    // Server-side title search (case-insensitive). Applied before order/range.
    final term = search?.trim() ?? '';
    if (term.isNotEmpty) {
      filter = filter.ilike('title', '%$term%');
    }

    final base = filter.order('created_at', ascending: false);

    // Page is 0-based; translate to an inclusive row range for the server.
    final data = limit != null
        ? await base.range((offset ?? 0) * limit, (offset ?? 0) * limit + limit - 1)
        : await base;

    printer("GET news: $data");

    return (data as List).map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
  }

/// ===================== player  ===========================

  Future<List<PlayerModel>> fetchPlayers() async {
    final data = await supabase.from('players').select();
    printer("GET players: $data");
    return (data as List).map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MatchEntryModel>> fetchMatchEntries() async {
    final data = await supabase.from('match_entries').select();
    printer("GET match_entries: $data");
    return (data as List).map((e) => MatchEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

/// ===================== rank home ===========================

  // Columns fetched from `players` for every rank query.
  static const String _playerCols = 'id, name, profileimageurl, playerroles, sort_name';

  Future<PlayerOfTheWeekAndMonthModel?> fetchPlayerOfTheWeekAndMonth() async {
    // Fetch the most recent award of each type with the related player row.
    final weekRow = await supabase
        .from('awards')
        .select('*, players($_playerCols)')
        .eq('award_type', 'player_of_week')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final monthRow = await supabase
        .from('awards')
        .select('*, players($_playerCols)')
        .eq('award_type', 'player_of_month')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (weekRow == null || monthRow == null) return null;

    final weekStats = await supabase
        .from('player_season_stats')
        .select()
        .eq('player_id', weekRow['player_id'])
        .eq('season_id', weekRow['season_id'])
        .maybeSingle();

    final monthStats = await supabase
        .from('player_season_stats')
        .select()
        .eq('player_id', monthRow['player_id'])
        .eq('season_id', monthRow['season_id'])
        .maybeSingle();

    final result = PlayerOfTheWeekAndMonthModel(
      season: weekRow['season_id']?.toString() ?? '',
      weekModel: _buildWeekModel(weekRow, weekStats),
      monthModel: _buildWeekModel(monthRow, monthStats),
    );
    printer("GET player of week/month: $result");
    return result;
  }
  
  Future<PlayerOfTheWeekAndMonthModel?> fetchScorerOfTheWeekAndMonth() async {
   // Fetch the most recent award of each type with the related player row.
    final weekRow = await supabase
        .from('awards')
        .select('*, players($_playerCols)')
        .eq('award_type', 'player_of_week')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final monthRow = await supabase
        .from('awards')
        .select('*, players($_playerCols)')
        .eq('award_type', 'player_of_month')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (weekRow == null || monthRow == null) return null;

    final weekStats = await supabase
        .from('player_season_stats')
        .select()
        .eq('player_id', weekRow['player_id'])
        .eq('season_id', weekRow['season_id'])
        .maybeSingle();

    final monthStats = await supabase
        .from('player_season_stats')
        .select()
        .eq('player_id', monthRow['player_id'])
        .eq('season_id', monthRow['season_id'])
        .maybeSingle();

    final result = PlayerOfTheWeekAndMonthModel(
      season: weekRow['season_id']?.toString() ?? '',
      weekModel: _buildWeekModel(weekRow, weekStats),
      monthModel: _buildWeekModel(monthRow, monthStats),
    );
    printer("GET player of week/month: $result");
    return result;
  }

  Future<List<LeaderboardPlayerModel>> fetchOverAllTopThreePlayer() async {
    final agg = await _aggregateAllSeasons();
    final sorted = agg.values.toList()
      ..sort((a, b) => _pts(b['wins'] as int, b['draws'] as int)
          .compareTo(_pts(a['wins'] as int, a['draws'] as int)));
    final result = sorted.take(3).map(_aggToLeaderboard).toList();
    printer("GET overall top 3 players: $result");
    return result;
  }

  Future<List<LeaderboardPlayerModel>> fetchSeasonalTopThreePlayer({required int season}) async {
    final data = await supabase
        .from('player_season_stats')
        .select('*, players($_playerCols)')
        .eq('season_id', season);
    final result = (data as List)
        .map((r) => _rowToLeaderboard(r['players'] as Map<String, dynamic>? ?? {}, r as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.pts.compareTo(a.pts));
    printer("GET seasonal top 3 players (season $season): $result");
    return result.take(3).toList();
  }

  Future<List<LeaderboardPlayerModel>> fetchOverAllTopThreeScorer() async {
    final agg = await _aggregateAllSeasons();
    final sorted = agg.values.toList()
      ..sort((a, b) => (b['goals'] as int).compareTo(a['goals'] as int));
    final result = sorted.take(3).map(_aggToLeaderboard).toList();
    printer("GET overall top 3 scorers: $result");
    return result;
  }

  Future<List<LeaderboardPlayerModel>> fetchSeasonalTopThreeScorer({required int season}) async {
    final data = await supabase
        .from('player_season_stats')
        .select('*, players($_playerCols)')
        .eq('season_id', season);
    final result = (data as List)
        .map((r) => _rowToLeaderboard(r['players'] as Map<String, dynamic>? ?? {}, r as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.goals.compareTo(a.goals));
    printer("GET seasonal top 3 scorers (season $season): $result");
    return result.take(3).toList();
  }

  // ========================= rank helpers ======================================

  // Fetch all player_season_stats rows joined with players, then aggregate
  // per player across all seasons.
  Future<Map<String, Map<String, dynamic>>> _aggregateAllSeasons() async {
    final data = await supabase
        .from('player_season_stats')
        .select('*, players($_playerCols)');
    final Map<String, Map<String, dynamic>> agg = {};
    for (final row in data as List) {
      final id = row['player_id']?.toString() ?? '';
      agg.putIfAbsent(id, () => {
        'player': row['players'], 'goals': 0, 'wins': 0, 'draws': 0, 'losses': 0, 'matches': 0,
      });
      agg[id]!['goals']   = (agg[id]!['goals']   as int) + ((row['goals']   as num?)?.toInt() ?? 0);
      agg[id]!['wins']    = (agg[id]!['wins']    as int) + ((row['wins']    as num?)?.toInt() ?? 0);
      agg[id]!['draws']   = (agg[id]!['draws']   as int) + ((row['draws']   as num?)?.toInt() ?? 0);
      agg[id]!['losses']  = (agg[id]!['losses']  as int) + ((row['losses']  as num?)?.toInt() ?? 0);
      agg[id]!['matches'] = (agg[id]!['matches'] as int) + ((row['matches'] as num?)?.toInt() ?? 0);
    }
    return agg;
  }

  LeaderboardPlayerModel _aggToLeaderboard(Map<String, dynamic> e) =>
      _rowToLeaderboard(
        (e['player'] as Map<String, dynamic>?) ?? {},
        {'goals': e['goals'], 'wins': e['wins'], 'draws': e['draws'],
         'losses': e['losses'], 'matches': e['matches']},
      );

  LeaderboardPlayerModel _rowToLeaderboard(
      Map<String, dynamic> player, Map<String, dynamic> stats) {
    final wins  = (stats['wins']  as num?)?.toInt() ?? 0;
    final draws = (stats['draws'] as num?)?.toInt() ?? 0;
    return LeaderboardPlayerModel(
      id:      player['id']?.toString() ?? '',
      name:    player['name']?.toString() ?? '',
      short:   player['sort_name']?.toString() ?? player['name']?.toString() ?? '',
      image:   player['profileimageurl']?.toString() ?? '',
      tags:    _readStringList(player['playerroles']),
      matches: (stats['matches'] as num?)?.toInt() ?? 0,
      wins:    wins,
      draws:   draws,
      losses:  (stats['losses']  as num?)?.toInt() ?? 0,
      goals:   (stats['goals']   as num?)?.toInt() ?? 0,
      pts:     _pts(wins, draws),
    );
  }

  PlayerOfTheWeeKModel _buildWeekModel(
      Map<String, dynamic> award, Map<String, dynamic>? stats) {
    final player = (award['players'] as Map<String, dynamic>?) ?? {};
    final wins  = (stats?['wins']  as num?)?.toInt() ?? 0;
    final draws = (stats?['draws'] as num?)?.toInt() ?? 0;
    return PlayerOfTheWeeKModel(
      season:  award['season_id']?.toString() ?? '',
      id:      player['id']?.toString() ?? '',
      name:    player['name']?.toString() ?? '',
      short:   player['sort_name']?.toString() ?? player['name']?.toString() ?? '',
      image:   player['profileimageurl']?.toString() ?? '',
      tags:    _readStringList(player['playerroles']),
      matches: (stats?['matches'] as num?)?.toInt() ?? 0,
      goals:   (stats?['goals']   as num?)?.toInt() ?? 0,
      pts:     _pts(wins, draws),
      wins:    wins,
    );
  }

  static int _pts(int wins, int draws) => wins * 3 + draws;

  static List<String> _readStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

}

