import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:supabase/supabase.dart';

class RankRepository implements RankRepositoryInterface {
  final SupabaseClient supabase;

  RankRepository({required this.supabase});

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth() {
    throw UnimplementedError();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() {
    throw UnimplementedError();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() {
    throw UnimplementedError();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() {
    throw UnimplementedError();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() {
    throw UnimplementedError();
  }
}
