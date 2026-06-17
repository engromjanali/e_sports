import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/enums/match_filter.dart';
import 'package:e_sports/core/helper/printer.dart';
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

      case AppConstants.profileUri:
        return fetchProfile(id: payload1 as String);

      case AppConstants.playerOfTheWeekAndMonth:
        return fetchPlayerOfTheWeekAndMonth(season: season);

      case AppConstants.scorerOfTheWeekAndMonth:
        return fetchScorerOfTheWeekAndMonth(season: season);

      case AppConstants.overAllTopThreePlayer:
        return fetchOverAllTopThreePlayer();

      case AppConstants.seasonalTopThreePlayer:
        return fetchSeasonalTopThreePlayer(season: season);

      case AppConstants.overAllTopThreeScorer:
        return fetchOverAllTopThreeScorer();

      case AppConstants.seasonalTopThreeScorer:
        return fetchSeasonalTopThreeScorer(season: season);

      // ── Server-driven rank: MVP cards (6) ──
      case AppConstants.weekMvpPlayer:
        return fetchWeekMvpPlayer(payload1 as Map<String, dynamic>);
      case AppConstants.weekMvpScorer:
        return fetchWeekMvpScorer(payload1 as Map<String, dynamic>);
      case AppConstants.monthMvpPlayer:
        return fetchMonthMvpPlayer(payload1 as Map<String, dynamic>);
      case AppConstants.monthMvpScorer:
        return fetchMonthMvpScorer(payload1 as Map<String, dynamic>);
      case AppConstants.seasonMvpPlayer:
        return fetchSeasonMvpPlayer(payload1 as Map<String, dynamic>);
      case AppConstants.seasonMvpScorer:
        return fetchSeasonMvpScorer(payload1 as Map<String, dynamic>);

      // ── Server-driven rank: list sections (3) ──
      case AppConstants.weeklyRanks:
      case AppConstants.monthlyRanks:
      case AppConstants.seasonStandings:
        return fetchRankList(payload1 as Map<String, dynamic>);

      // ── Server-driven rank: player detail ──
      case AppConstants.playerRankDetail:
        return fetchPlayerRankDetail(payload1 as Map<String, dynamic>);

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

      case AppConstants.loginUri:
        final creds = payload1 as Map<String, dynamic>;
        return fetchPlayerByCredentials(
          email: creds['email'] as String,
          password: creds['password'] as String,
        );

      case AppConstants.profileUri:
        final p = payload1 as Map<String, dynamic>;
        return updateProfile(
          id: p['id'] as String,
          name: p['name'] as String,
          sortName: p['sort_name'] as String,
          email: p['email'] as String?,
        );

      default:
        throw "end-point not found";

    }
  }

/// ==================== config ========================

  Future<Map<String, dynamic>> fetchConfig() async {
    final settings = await supabase.from('app_settings').select().single();
    final seasonRows = await supabase
        .from('season')
        .select('id, name, status, start_date, end_date')
        .order('id', ascending: true);

    final merged = {
      'version':          settings['version'],
      'verify_email':     settings['verify_email'],
      'maintenance_mode': settings['maintenance_mode'],
      'current_season':   settings['current_season_id'],
      'seasons':          seasonRows,
    };

    printer("GET ${AppConstants.configUri}: $merged");
    return merged;
  }

/// ==================== match ========================

  Future<List<Map<String, dynamic>>> fetchMatchHome({required int season, required int limit}) async {
    // Live matches take priority on the home screen (most recent first).
    final liveMatches = await supabase
        .from('matches')
        .select('*, competitions(name)')
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
          .select('*, competitions(name)')
          .eq('season_id', season)
          .eq('status', MatchFilter.upcoming.name)
          .order('date', ascending: true)
          .limit(remaining);

      result.addAll(upcomingMatches);
    }

    printer("GET ${AppConstants.homeMatch}: $result");
    return result.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchMatch({required MatchFilter type, required int season, required int limit, required int offset}) async {
    var query = supabase.from('matches').select('*, competitions(name)').eq('season_id', season);

    if (type != MatchFilter.all) {
      query = query.eq('status', type.name);
    }

    // Page is 0-based; translate to an inclusive row range for the server.
    final data = await query.range(
      offset * limit,
      offset * limit + limit - 1,
    );

    printer("GET ${AppConstants.matches}: $data");

    return (data as List).cast<Map<String, dynamic>>();
  }
    
/// ===================== news ===========================

  Future<List<Map<String, dynamic>>> fetchNews({int? limit, int? offset, String? search}) async {
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

    return (data as List).cast<Map<String, dynamic>>();
  }

/// ===================== faq ===========================

  Future<List<Map<String, dynamic>>> fetchFaqs() async {
    final data = await supabase
        .from('faqs')
        .select()
        .eq('is_active', true)
        .order('display_order', ascending: true)
        .order('id', ascending: true);
    printer("GET faqs: $data");
    return (data as List).cast<Map<String, dynamic>>();
  }

/// ===================== auth ===========================

  /// Returns the player's UUID if email + password match a row in `players`,
  /// or null if no match is found.
  Future<String?> fetchPlayerByCredentials({required String email, required String password}) async {
    final data = await supabase
        .from('players')
        .select('id')
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    final id = data?['id']?.toString();
    printer("AUTH fetchPlayerByCredentials: ${id != null ? 'found' : 'not found'}");
    return id;
  }

/// ===================== profile ===========================

  // Columns + relations for a single player's profile row.
  static const String _profileCols =
      '*, player_player_roles(player_role(name)), player_custom_tags(custom_tags(name))';

  Future<Map<String, dynamic>?> fetchProfile({required String id}) async {
    final data = await supabase
        .from('players')
        .select(_profileCols)
        .eq('id', id)
        .maybeSingle();
    printer("GET profile ($id): $data");
    return data;
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String id,
    required String name,
    required String sortName,
    String? email,
  }) async {
    final data = await supabase
        .from('players')
        .update({
          'name': name,
          'sort_name': sortName,
          'email': ?email,
        })
        .eq('id', id)
        .select(_profileCols)
        .maybeSingle();
    printer("UPDATE profile ($id): $data");
    return data;
  }

/// ===================== player  ===========================

  Future<List<Map<String, dynamic>>> fetchPlayers() async {
    final data = await supabase.from('players').select(
      '*, player_player_roles(player_role(name)), player_custom_tags(custom_tags(name))',
    );
    printer("GET players: $data");
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchMatchEntries() async {
    // No FK to `matches`; join the match date manually by matchid and inject it
    // as `matches.date` so MatchEntryModel.fromJson keeps working unchanged.
    final matchDates = await _matchDateMap();
    final data = (await supabase.from('match_entries').select('*') as List)
        .cast<Map<String, dynamic>>();
    for (final row in data) {
      final d = matchDates[row['matchid']?.toString()];
      row['matches'] = {'date': d?.toIso8601String()};
    }
    printer("GET match_entries: $data");
    return data;
  }

/// ===================== my rank ===========================

  Future<Map<String, dynamic>?> fetchMyRank({required String playerId, required int seasonId}) async {
    final data = await supabase
        .from('player_season_stats')
        .select()
        .eq('season_id', seasonId);

    final rows = (data as List).cast<Map<String, dynamic>>();

    // Sort all rows by pts descending (same formula used everywhere)
    rows.sort((a, b) => _ptsFromMap(b).compareTo(_ptsFromMap(a)));

    final idx = rows.indexWhere((r) => r['player_id']?.toString() == playerId);
    if (idx == -1) {
      printer("GET myRank: player $playerId not found in season $seasonId stats");
      return null;
    }

    // Return the matched row with the server-computed rank + pts attached.
    final result = {...rows[idx], 'rank': idx + 1, 'pts': _ptsFromMap(rows[idx])};
    printer("GET myRank: rank=${result['rank']} pts=${result['pts']} for player $playerId");
    return result;
  }

/// ===================== rank home ===========================

  // Columns fetched from `players` for rank queries — includes role junction.
  static const String _playerCols =
      'id, name, profileimageurl, sort_name, player_player_roles(player_role(name))';

  // Player / Scorer of the week & month for the HOME screen spotlight.
  // Computed live from match_entries (joined to matches for the date and players
  // for display), since the awards table was removed. "Week" = last 7 days,
  // "Month" = current calendar month. Player ranks by points; Scorer by goals.
  //
  // NOTE: this is a rolling-window single-top, intentionally DIFFERENT from the
  // Rank screen's selectable season periods (SeasonModel.weeks/months, which are
  // 7-day chunks / calendar months sliced from the season start). The home
  // spotlight deliberately keeps the simpler rolling window.
  Future<Map<String, dynamic>?> fetchPlayerOfTheWeekAndMonth({required int season}) async =>
      _fetchTopOfWeekAndMonth(season: season, byGoals: false);

  Future<Map<String, dynamic>?> fetchScorerOfTheWeekAndMonth({required int season}) async =>
      _fetchTopOfWeekAndMonth(season: season, byGoals: true);

  Future<Map<String, dynamic>?> _fetchTopOfWeekAndMonth({required int season, required bool byGoals}) async {
    final matchDates = await _matchDateMap();
    final data = await supabase
        .from('match_entries')
        .select('*, players($_playerCols)')
        .eq('season_id', season);

    final rows = (data as List).cast<Map<String, dynamic>>();
    // Inject the manually-joined date so _topInRange can read matches.date.
    for (final row in rows) {
      final d = matchDates[row['matchid']?.toString()];
      row['matches'] = {'date': d?.toIso8601String()};
    }

    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month, 1);

    final week = _topInRange(rows, since: weekStart, byGoals: byGoals);
    final month = _topInRange(rows, since: monthStart, byGoals: byGoals);

    if (week == null && month == null) {
      printer("GET ${byGoals ? 'scorer' : 'player'} of week/month: no entries in range");
      return null;
    }

    // Raw shape consumed by PlayerOfTheWeekAndMonthModel.fromJson on the repo side.
    return {
      'season': season.toString(),
      'week_model': week,
      'month_model': month,
    };
  }

  // Aggregate entries whose match date is on/after [since], then return the top
  // player (by goals or points) as a PlayerOfTheWeeKModel, or null if none.
  Map<String, dynamic>? _topInRange(
    List<Map<String, dynamic>> rows, {
    required DateTime since,
    required bool byGoals,
  }) {
    final Map<String, Map<String, dynamic>> agg = {};

    for (final row in rows) {
      final dateStr = (row['matches'] as Map<String, dynamic>?)?['date']?.toString();
      final date = DateTime.tryParse(dateStr ?? '');
      if (date == null || date.isBefore(since)) continue;

      final id = row['playerid']?.toString() ?? '';
      if (id.isEmpty) continue;

      final a = agg.putIfAbsent(id, () => {
        'player': row['players'],
        'goals': 0, 'wins': 0, 'draws': 0, 'losses': 0,
        'matches': 0, 'goalsconceded': 0, 'motmcount': 0, 'hattricks': 0,
      });

      final result = row['result']?.toString();
      a['matches']       = (a['matches']       as int) + 1;
      a['goals']         = (a['goals']         as int) + ((row['goals']         as num?)?.toInt() ?? 0);
      a['goalsconceded'] = (a['goalsconceded'] as int) + ((row['goalsconceded'] as num?)?.toInt() ?? 0);
      a['hattricks']     = (a['hattricks']     as int) + ((row['hattricks']     as num?)?.toInt() ?? 0);
      if (result == 'win')  a['wins']   = (a['wins']   as int) + 1;
      if (result == 'draw') a['draws']  = (a['draws']  as int) + 1;
      if (result == 'loss') a['losses'] = (a['losses'] as int) + 1;
      if (row['motm'] == true) a['motmcount'] = (a['motmcount'] as int) + 1;
    }

    if (agg.isEmpty) return null;

    final list = agg.values.toList()
      ..sort((x, y) => byGoals
          ? (y['goals'] as int).compareTo(x['goals'] as int)
          : _ptsFromMap(y).compareTo(_ptsFromMap(x)));

    final top = list.first;
    final player = (top['player'] as Map<String, dynamic>?) ?? {};
    // Raw shape matching PlayerOfTheWeeKModel.fromJson (all keys non-null).
    return {
      'season':  '',
      'id':      player['id']?.toString() ?? '',
      'name':    player['name']?.toString() ?? '',
      'short':   player['sort_name']?.toString() ?? player['name']?.toString() ?? '',
      'image':   player['profileimageurl']?.toString() ?? '',
      'tags':    _readNestedNames(player['player_player_roles'], 'player_role'),
      'matches': top['matches'] as int,
      'goals':   top['goals'] as int,
      'pts':     _ptsFromMap(top),
      'wins':    top['wins'] as int,
    };
  }

  Future<List<Map<String, dynamic>>> fetchOverAllTopThreePlayer() async {
    final agg = await _aggregateAllSeasons();
    final sorted = agg.values.toList()
      ..sort((a, b) => _ptsFromMap(b).compareTo(_ptsFromMap(a)));
    final result = sorted.take(3).map(_aggToLeaderboardMap).toList();
    printer("GET overall top 3 players: $result");
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchSeasonalTopThreePlayer({required int season}) async {
    final data = await supabase
        .from('player_season_stats')
        .select('*, players($_playerCols)')
        .eq('season_id', season);
    final result = (data as List)
        .map((r) => _rowToLeaderboardMap(r['players'] as Map<String, dynamic>? ?? {}, r as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => (b['pts'] as int).compareTo(a['pts'] as int));
    printer("GET seasonal top 3 players (season $season): $result");
    return result.take(3).toList();
  }

  Future<List<Map<String, dynamic>>> fetchOverAllTopThreeScorer() async {
    final agg = await _aggregateAllSeasons();
    final sorted = agg.values.toList()
      ..sort((a, b) => (b['goals'] as int).compareTo(a['goals'] as int));
    final result = sorted.take(3).map(_aggToLeaderboardMap).toList();
    printer("GET overall top 3 scorers: $result");
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchSeasonalTopThreeScorer({required int season}) async {
    final data = await supabase
        .from('player_season_stats')
        .select('*, players($_playerCols)')
        .eq('season_id', season);
    final result = (data as List)
        .map((r) => _rowToLeaderboardMap(r['players'] as Map<String, dynamic>? ?? {}, r as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => (b['goals'] as int).compareTo(a['goals'] as int));
    printer("GET seasonal top 3 scorers (season $season): $result");
    return result.take(3).toList();
  }

/// ===================== server-driven rank (per-section) =====================

  // Payload keys: season_id:int?, start:ISO, end:ISO, type:'player'|'scorer',
  // overall:bool?, player_id:String?, limit:int?.

  // ── MVP wrappers (6): each returns the single top player map, or null. ──
  Future<Map<String, dynamic>?> fetchWeekMvpPlayer(Map<String, dynamic> p)   => _topRankInRange(p, byGoals: false);
  Future<Map<String, dynamic>?> fetchWeekMvpScorer(Map<String, dynamic> p)   => _topRankInRange(p, byGoals: true);
  Future<Map<String, dynamic>?> fetchMonthMvpPlayer(Map<String, dynamic> p)  => _topRankInRange(p, byGoals: false);
  Future<Map<String, dynamic>?> fetchMonthMvpScorer(Map<String, dynamic> p)  => _topRankInRange(p, byGoals: true);
  Future<Map<String, dynamic>?> fetchSeasonMvpPlayer(Map<String, dynamic> p) => _topRankInRange(p, byGoals: false);
  Future<Map<String, dynamic>?> fetchSeasonMvpScorer(Map<String, dynamic> p) => _topRankInRange(p, byGoals: true);

  Future<Map<String, dynamic>?> _topRankInRange(Map<String, dynamic> p, {required bool byGoals}) async {
    final list = await _rankEntriesInRange(
      seasonId: p['season_id'] as int?,
      start: DateTime.parse(p['start'].toString()).toUtc(),
      end: DateTime.parse(p['end'].toString()).toUtc(),
      byGoals: byGoals,
      overall: p['overall'] == true,
    );
    return list.isEmpty ? null : list.first;
  }

  // ── List sections (3): full ranked list (player or scorer order). ──
  Future<List<Map<String, dynamic>>> fetchRankList(Map<String, dynamic> p) async {
    final list = await _rankEntriesInRange(
      seasonId: p['season_id'] as int?,
      start: DateTime.parse(p['start'].toString()).toUtc(),
      end: DateTime.parse(p['end'].toString()).toUtc(),
      byGoals: p['type'] == 'scorer',
      overall: p['overall'] == true,
    );
    final limit = p['limit'] as int?;
    return limit == null ? list : list.take(limit).toList();
  }

  // ── Player detail: rank + aggregates for the window + last-20 / history. ──
  Future<Map<String, dynamic>?> fetchPlayerRankDetail(Map<String, dynamic> p) async {
    final playerId = p['player_id'].toString();
    final seasonId = p['season_id'] as int?;
    final overall = p['overall'] == true || seasonId == null;
    final start = DateTime.parse(p['start'].toString()).toUtc();
    final end = DateTime.parse(p['end'].toString()).toUtc();

    final ranked = await _rankEntriesInRange(
      seasonId: seasonId, start: start, end: end, byGoals: false, overall: overall,
    );
    final me = ranked.firstWhereOrNull((r) => r['id'] == playerId);
    if (me == null) {
      printer("GET rank detail: $playerId not found in range");
      return null;
    }

    // This player's entries (most-recent first) for last-20 + match history.
    // Date is joined manually by matchid (no FK between match_entries/matches).
    final matchDates = await _matchDateMap();
    var eq = supabase
        .from('match_entries')
        .select('*')
        .eq('playerid', playerId);
    if (!overall) eq = eq.eq('season_id', seasonId);
    final entryRows = (await eq) as List;

    final entries = entryRows
        .map((e) => e as Map<String, dynamic>)
        .where((e) {
          final d = matchDates[e['matchid']?.toString()];
          return d != null && !d.isBefore(start) && d.isBefore(end);
        })
        .toList()
      ..sort((a, b) {
        final da = matchDates[a['matchid']?.toString()] ?? DateTime(2000);
        final db = matchDates[b['matchid']?.toString()] ?? DateTime(2000);
        return db.compareTo(da);
      });

    // Attach the resolved date so RankDetailMatch.fromJson can read it.
    for (final e in entries) {
      e['date'] = matchDates[e['matchid']?.toString()]?.toIso8601String();
    }

    final last20 = entries.take(20).map((e) => e['result']?.toString() ?? 'draw').toList();
    int cleansheets = 0;
    for (final e in entries) {
      if (e['cleansheet'] == true) cleansheets++;
    }

    final result = {
      ...me,
      'cleansheets': cleansheets,
      'last20': last20,
      'match_history': entries.take(20).toList(),
    };
    printer("GET rank detail ($playerId): rank=${result['rank']} pts=${result['pts']}");
    return result;
  }

  // Aggregate match_entries for [seasonId] within [start,end), one row per player,
  // ranked by pts (byGoals=false) or goals (byGoals=true). Replicates
  // StatsService.calculateMatchPoints (per-match) so numbers match the app.
  // `match_entries` has no FK to `matches`, so PostgREST can't embed the date.
  // The date is joined manually by matchid via this map.
  Future<Map<String, DateTime>> _matchDateMap() async {
    final rows = (await supabase.from('matches').select('id, date') as List)
        .cast<Map<String, dynamic>>();
    final map = <String, DateTime>{};
    for (final r in rows) {
      final d = DateTime.tryParse(r['date']?.toString() ?? '');
      if (d != null) map[r['id'].toString()] = d.toUtc();
    }
    return map;
  }

  Future<List<Map<String, dynamic>>> _rankEntriesInRange({
    required int? seasonId,
    required DateTime start,
    required DateTime end,
    required bool byGoals,
    bool overall = false,
  }) async {
    final matchDates = await _matchDateMap();
    var q = supabase
        .from('match_entries')
        .select('*, players($_playerCols)');
    if (!overall && seasonId != null) q = q.eq('season_id', seasonId);
    final rows = (await q as List).cast<Map<String, dynamic>>();

    final s = start.toUtc();
    final e = end.toUtc();
    final Map<String, Map<String, dynamic>> agg = {};

    for (final row in rows) {
      final d = matchDates[row['matchid']?.toString()];
      if (d == null || d.isBefore(s) || !d.isBefore(e)) continue;

      final id = row['playerid']?.toString() ?? '';
      if (id.isEmpty) continue;

      final a = agg.putIfAbsent(id, () => {
        'player': row['players'],
        'matches': 0, 'goals': 0, 'gf': 0, 'ga': 0,
        'wins': 0, 'draws': 0, 'losses': 0, 'pts': 0,
      });

      final result = row['result']?.toString();
      final goals = (row['goals'] as num?)?.toInt() ?? 0;
      final conceded = (row['goalsconceded'] as num?)?.toInt() ?? 0;
      final hattrick = ((row['hattricks'] as num?)?.toInt() ?? 0) > 0;
      final motm = row['motm'] == true;

      a['matches'] = (a['matches'] as int) + 1;
      a['goals'] = (a['goals'] as int) + goals;
      a['gf'] = (a['gf'] as int) + goals;
      a['ga'] = (a['ga'] as int) + conceded;
      if (result == 'win') a['wins'] = (a['wins'] as int) + 1;
      if (result == 'draw') a['draws'] = (a['draws'] as int) + 1;
      if (result == 'loss') a['losses'] = (a['losses'] as int) + 1;

      // StatsService.calculateMatchPoints, summed per match.
      int mp = 0;
      if (result == 'win') mp += 3;
      if (result == 'draw') mp += 1;
      if (result == 'loss') mp -= 1;
      mp += goals - conceded;
      if (hattrick) mp += 1;
      if (motm) mp += 2;
      a['pts'] = (a['pts'] as int) + mp;
    }

    final list = agg.values.map(_aggToRankMap).toList();
    list.sort((x, y) {
      if (byGoals) {
        if (y['goals'] != x['goals']) return (y['goals'] as int).compareTo(x['goals'] as int);
        return (y['pts'] as int).compareTo(x['pts'] as int);
      }
      if (y['pts'] != x['pts']) return (y['pts'] as int).compareTo(x['pts'] as int);
      if (y['goals'] != x['goals']) return (y['goals'] as int).compareTo(x['goals'] as int);
      return ((y['gf'] as int) - (y['ga'] as int)).compareTo((x['gf'] as int) - (x['ga'] as int));
    });
    for (int i = 0; i < list.length; i++) {
      list[i]['rank'] = i + 1;
    }
    return list;
  }

  // Aggregated rank entry -> flat display map (tags pre-computed server-side).
  Map<String, dynamic> _aggToRankMap(Map<String, dynamic> a) {
    final player = (a['player'] as Map<String, dynamic>?) ?? {};
    return {
      'id':      player['id']?.toString() ?? '',
      'name':    player['name']?.toString() ?? '',
      'short':   player['sort_name']?.toString() ?? player['name']?.toString() ?? '',
      'image':   player['profileimageurl']?.toString() ?? '',
      'tags':    _readNestedNames(player['player_player_roles'], 'player_role'),
      'rank':    0,
      'matches': a['matches'] as int,
      'wins':    a['wins'] as int,
      'draws':   a['draws'] as int,
      'losses':  a['losses'] as int,
      'goals':   a['goals'] as int,
      'gf':      a['gf'] as int,
      'ga':      a['ga'] as int,
      'pts':     a['pts'] as int,
    };
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
        'player': row['players'],
        'goals': 0, 'wins': 0, 'draws': 0, 'losses': 0, 'appearances': 0,
        'goalsconceded': 0, 'motmcount': 0, 'hattricks': 0,
      });
      agg[id]!['goals']         = (agg[id]!['goals']         as int) + ((row['goals']         as num?)?.toInt() ?? 0);
      agg[id]!['wins']          = (agg[id]!['wins']          as int) + ((row['wins']          as num?)?.toInt() ?? 0);
      agg[id]!['draws']         = (agg[id]!['draws']         as int) + ((row['draws']         as num?)?.toInt() ?? 0);
      agg[id]!['losses']        = (agg[id]!['losses']        as int) + ((row['losses']        as num?)?.toInt() ?? 0);
      agg[id]!['appearances']   = (agg[id]!['appearances']   as int) + ((row['appearances']   as num?)?.toInt() ?? 0);
      agg[id]!['goalsconceded'] = (agg[id]!['goalsconceded'] as int) + ((row['goalsconceded'] as num?)?.toInt() ?? 0);
      agg[id]!['motmcount']     = (agg[id]!['motmcount']     as int) + ((row['motmcount']     as num?)?.toInt() ?? 0);
      agg[id]!['hattricks']     = (agg[id]!['hattricks']     as int) + ((row['hattricks']     as num?)?.toInt() ?? 0);
    }
    return agg;
  }

  // Aggregated cross-season entry -> flat leaderboard map.
  Map<String, dynamic> _aggToLeaderboardMap(Map<String, dynamic> e) =>
      _rowToLeaderboardMap(
        (e['player'] as Map<String, dynamic>?) ?? {},
        {
          'goals': e['goals'], 'wins': e['wins'], 'draws': e['draws'],
          'losses': e['losses'], 'appearances': e['appearances'],
          'goalsconceded': e['goalsconceded'], 'motmcount': e['motmcount'],
          'hattricks': e['hattricks'],
        },
      );

  // Player row + stats row -> flat leaderboard map (tags/pts pre-computed
  // server-side) matching the LeaderboardPlayerModel fields the repo builds.
  Map<String, dynamic> _rowToLeaderboardMap(
      Map<String, dynamic> player, Map<String, dynamic> stats) {
    return {
      'id':      player['id']?.toString() ?? '',
      'name':    player['name']?.toString() ?? '',
      'short':   player['sort_name']?.toString() ?? player['name']?.toString() ?? '',
      'image':   player['profileimageurl']?.toString() ?? '',
      'tags':    _readNestedNames(player['player_player_roles'], 'player_role'),
      'matches': (stats['appearances'] as num?)?.toInt() ?? 0,
      'wins':    (stats['wins']    as num?)?.toInt() ?? 0,
      'draws':   (stats['draws']   as num?)?.toInt() ?? 0,
      'losses':  (stats['losses']  as num?)?.toInt() ?? 0,
      'goals':   (stats['goals']   as num?)?.toInt() ?? 0,
      'pts':     _ptsFromMap(stats),
    };
  }


static int _pts({
    required int wins,
    required int draws,
    required int losses,
    required int goals,
    required int goalsConceded,
    required int motmCount,
    required int hattricks,
  }) =>
      wins * 3 + draws - losses + goals - goalsConceded + motmCount * 2 + hattricks;

  int _ptsFromMap(Map<String, dynamic> m) => _pts(
        wins:          (m['wins']          as num?)?.toInt() ?? 0,
        draws:         (m['draws']         as num?)?.toInt() ?? 0,
        losses:        (m['losses']        as num?)?.toInt() ?? 0,
        goals:         (m['goals']         as num?)?.toInt() ?? 0,
        goalsConceded: (m['goalsconceded'] as num?)?.toInt() ?? 0,
        motmCount:     (m['motmcount']     as num?)?.toInt() ?? 0,
        hattricks:     (m['hattricks']     as num?)?.toInt() ?? 0,
      );

  static List<String> _readNestedNames(dynamic list, String key) {
    if (list is! List) return const [];
    return list
        .map((item) =>
            (item[key] as Map<String, dynamic>?)?['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
  }

}

