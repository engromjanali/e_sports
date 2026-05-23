import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:e_sports/features/splash/domain/services/splash_service_interface.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;

  SplashController({required this.splashServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  Future<bool> getConfig() async {
    _isLoading = true;
    update();
    _configModel = await splashServiceInterface.getConfig();
    _isLoading = false;
    update();
    return _configModel != null;
  }
}
