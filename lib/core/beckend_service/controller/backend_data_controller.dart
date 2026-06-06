import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/data/models/match_model.dart';
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
        return fetchMatch(type: payload1 ?? MatchFilter.all, season: season, limit: limit ?? 10, offset: offset ?? 1);

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
        return fetchMatch(type: payload1 ?? MatchFilter.all, season: season, limit: limit ?? 10, offset: offset ?? 1);

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

    final data = await query.range(
      offset,
      offset + limit - 1,
    );

    printer("GET matches: $data");

    return (data as List).map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }
    
/// ===================== player  ===========================

}

