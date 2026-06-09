import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository_interface.dart';

class SplashRepository implements SplashRepositoryInterface {
  final BackendDataController backendDataController;

  SplashRepository({required this.backendDataController});

  @override
  Future<ConfigModel> getConfig() async {
    return await backendDataController.getData(
      AppConstants.configUri,
      season: 0,
    ) as ConfigModel;
  }
}
