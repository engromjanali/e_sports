import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository_interface.dart';
import 'package:get/get.dart';

class PlayerRepository implements PlayerRepositoryInterface {
  @override
  Future<List<PlayerModel>> getPlayers() async {
    final response = await Get.find<ApiClient>().getData(AppConstants.players, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    final response = await Get.find<ApiClient>().getData(AppConstants.matchEntries, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => MatchEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<MyRankModel?> getMyRank() async {
    final response = await Get.find<ApiClient>().getData(AppConstants.myRank, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return MyRankModel.fromJson(body);
  }

  @override
  Future<List<PlayerModel>> searchPlayers({
    String? search,
    int limit = 20,
    int offset = 1,
  }) async {
    // GET /api/user/players?search=&limit=&offset= — identity only, no season.
    final params = <String, String>{
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    final uri = Uri.parse(AppConstants.players).replace(queryParameters: params).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ComputedPlayerStats?> getPlayerStats({required String playerId, int? seasonId}) async {
    // GET /api/user/player-stats?player_id=&season= — stats for one player in a
    // season. Season falls back to the X-Season-Id header when null.
    final params = <String, String>{
      'player_id': playerId,
      if (seasonId != null) 'season': seasonId.toString(),
    };
    final uri = Uri.parse(AppConstants.playerStats).replace(queryParameters: params).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return _toComputed(body);
  }

  // Maps a player-stats row into the ComputedPlayerStats the compare/profile UI reads.
  ComputedPlayerStats _toComputed(Map<String, dynamic> m) {
    int field(String k) => (m[k] as num?)?.toInt() ?? 0;
    final goals = field('goals');
    return ComputedPlayerStats(
      player: PlayerModel(
        id: m['id']?.toString() ?? '',
        name: m['name']?.toString() ?? '',
        sortName: m['sort_name']?.toString() ?? '',
        jerseyNumber: field('jerseynumber'),
        imageUrl: m['image']?.toString() ?? '',
        playerRoles: List<String>.from(m['tags'] ?? const []),
      ),
      matches: field('matches'),
      wins: field('wins'),
      draws: field('draws'),
      losses: field('losses'),
      goals: goals,
      gf: goals,
      ga: field('ga'),
      rank: field('rank'),
      cleansheets: field('cleansheets'),
      motm: field('motm'),
      hattricks: field('hattricks'),
      pts: field('pts'),
      last20: List<String>.from(m['last20'] ?? const []),
      matchHistory: (m['match_history'] as List? ?? const [])
          .map((e) => MatchEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
