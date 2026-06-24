import 'package:e_sports/features/splash/domain/models/config_model.dart';

abstract class SplashServiceInterface {
  Future<ConfigModel?> getConfig();
}
