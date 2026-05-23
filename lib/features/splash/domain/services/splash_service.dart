import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:e_sports/features/splash/domain/services/splash_service_interface.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepositoryInterface splashRepositoryInterface;

  SplashService({required this.splashRepositoryInterface});

  @override
  Future<ConfigModel?> getConfig() async {
    try {
      return await splashRepositoryInterface.getConfig();
    } on AppException catch (e) {
      printer('[SplashService.getConfig] ${e.message}');
      return null;
    } catch (e) {
      printer('[SplashService.getConfig] Unexpected: $e');
      return null;
    }
  }
}
