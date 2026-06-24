import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';

/// Server-driven Hall of Fame data (Django). One call returns every award
/// category with its entries.
abstract class HallOfFameRepositoryInterface {
  Future<List<HofCategoryModel>> getHallOfFame();
}
