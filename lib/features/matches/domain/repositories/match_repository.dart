import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/data/models/match_model.dart';
import 'package:e_sports/core/enums/match_filter.dart';

import 'package:e_sports/features/matches/domain/repositories/match_repository_interface.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class MatchRepository implements MatchRepositoryInterface {
  final SupabaseClient supabase;

  MatchRepository({required this.supabase});

  @override
  Future<List<MatchModel>> getHomeMatches() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.homeMatch,
      season: AppConstants.currentSeason,
      limit: 3,
    );
    return List<MatchModel>.from(data as List);
  }

  @override
  Future<List<MatchModel>> getMatches({
    MatchFilter type = MatchFilter.all,
    int limit = 10,
    int offset = 0,
  }) async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.matches,
      payload1: type,
      season: AppConstants.currentSeason,
      limit: limit,
      offset: offset,
    );
    return List<MatchModel>.from(data as List);
  }
}
