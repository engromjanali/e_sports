import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/core/enums/match_filter.dart';

import 'package:e_sports/features/matches/domain/repositories/match_repository_interface.dart';
import 'package:e_sports/features/matches/domain/services/match_service_interface.dart';

class MatchService implements MatchServiceInterface {
  final MatchRepositoryInterface matchRepositoryInterface;

  MatchService({required this.matchRepositoryInterface});

  @override
  Future<List<MatchModel>> getHomeMatches() async {
    try {
      return await matchRepositoryInterface.getHomeMatches();
    } on AppException catch (e) {
      printer('[MatchService.getHomeMatches] ${e.message}');
      return [];
    } catch (e) {
      printer('[MatchService.getHomeMatches] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<MatchModel>> getMatches({
    MatchFilter type = MatchFilter.all,
    int limit = 10,
    int offset = 1,
    required int season,
  }) async {
    try {
      return await matchRepositoryInterface.getMatches(
        type: type,
        limit: limit,
        offset: offset,
        season: season,
      );
    } on AppException catch (e) {
      printer('[MatchService.getMatches] ${e.message}');
      return [];
    } catch (e) {
      printer('[MatchService.getMatches] Unexpected: $e');
      return [];
    }
  }

  /// Picks the matches highlighted on the home screen.
  ///
  /// Live matches take first priority; if there are fewer than [limit] live
  /// matches, the remaining slots are filled with upcoming matches sorted by
  /// date (soonest kick-off first). The result is capped at [limit].
  static List<MatchModel> selectHomeMatches(List<MatchModel> all, {int limit = 3}) {
    final live = all.where((m) => m.status == 'live').toList();
    final upcoming = all.where((m) => m.status == 'upcoming').toList()
      ..sort((a, b) => _parseDate(a.date).compareTo(_parseDate(b.date)));

    final result = <MatchModel>[...live.take(limit)];
    for (final m in upcoming) {
      if (result.length >= limit) break;
      result.add(m);
    }
    return result;
  }

  // Unparseable dates sort last so real, dated matches surface first.
  static DateTime _parseDate(String raw) =>
      DateTime.tryParse(raw) ?? DateTime(9999);
}
