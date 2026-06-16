import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
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
      AppConstants.homeMatch,  season: AppHelper.season,limit: 3,);
    return (data as List).map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MatchModel>> getMatches({MatchFilter type = MatchFilter.all, int limit = 10, int offset = 0, required int season}) async {
    final data = await Get.find<BackendDataController>().getData(AppConstants.matches, payload1: type, season: season, limit: limit, offset: offset,);
    return (data as List).map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
