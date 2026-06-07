import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
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
      case AppConstants.homeMatch:
        return fetchMatchHome(season: season, limit: limit ?? 3);

      case AppConstants.matches:
        return fetchMatch(type: payload1 ?? MatchFilter.all, season: season, limit: limit ?? 10, offset: offset ?? 0);

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

/// ==================== match ========================

  Future<List<MatchModel>> fetchMatchHome({required int season, required int limit}) async {
    // Get live matches first
    final liveMatches = await supabase.from('matches').select().eq('season', season).eq('status', MatchFilter.live.name).limit(limit);

    final List<dynamic> result = [...liveMatches];

    // Fill remaining slots with upcoming matches
    final remaining = limit - result.length;

    if (remaining > 0) {
      final upcomingMatches = await supabase.from('matches').select().eq('season', season).eq('status', MatchFilter.upcoming.name).limit(remaining);

      result.addAll(upcomingMatches);
    }

    printer("GET matches: $result");
    return result.map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MatchModel>> fetchMatch({required MatchFilter type, required int season, required int limit, required int offset}) async {
    var query = supabase.from('matches').select().eq('season', season);

    if (type != MatchFilter.all) {
      query = query.eq('status', type.name);
    }

    // Page is 0-based; translate to an inclusive row range for the server.
    final data = await query.range(
      offset * limit,
      offset * limit + limit - 1,
    );

    printer("GET matches: $data");

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

}

