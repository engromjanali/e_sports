import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';
import 'package:e_sports/features/hall_of_fame/domain/repositories/hall_of_fame_repository_interface.dart';
import 'package:e_sports/features/hall_of_fame/domain/services/hall_of_fame_service_interface.dart';

class HallOfFameService implements HallOfFameServiceInterface {
  final HallOfFameRepositoryInterface hallOfFameRepositoryInterface;

  HallOfFameService({required this.hallOfFameRepositoryInterface});

  // Runs [call], swallowing failures to [fallback] (errors already typed by ApiClient).
  Future<T> _guard<T>(String tag, T fallback, Future<T> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      printer('[HallOfFameService.$tag] ${e.message}');
      return fallback;
    } catch (e) {
      printer('[HallOfFameService.$tag] Unexpected: $e');
      return fallback;
    }
  }

  @override
  Future<List<HofCategoryModel>> getHallOfFame() => _guard(
        'getHallOfFame',
        <HofCategoryModel>[],
        () => hallOfFameRepositoryInterface.getHallOfFame(),
      );
}
