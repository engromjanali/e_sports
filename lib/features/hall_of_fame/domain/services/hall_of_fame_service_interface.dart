import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';

abstract class HallOfFameServiceInterface {
  Future<List<HofCategoryModel>> getHallOfFame();
}
