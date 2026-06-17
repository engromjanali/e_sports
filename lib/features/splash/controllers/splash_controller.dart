import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
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

  bool get isUpdateRequired => _isCurrentVersionLower(_configModel?.version);
  bool get shouldShowMaintenance => _configModel?.maintenanceMode == true || isUpdateRequired;

  Future<bool> getConfig() async {
    _isLoading = true;
    update();
    _configModel = await splashServiceInterface.getConfig();
    Get.find<ApiClient>().updateSeasonHeader(_configModel?.currentSeason);
    _isLoading = false;
    update();
    return _configModel != null;
  }

  bool _isCurrentVersionLower(String? configVersion) {
    if(configVersion == null || configVersion.isEmpty) {
      return false;
    }

    final List<int> currentParts = _versionParts(AppConstants.appVersion);
    final List<int> configParts = _versionParts(configVersion);
    final int length = currentParts.length > configParts.length ? currentParts.length : configParts.length;

    for(int index = 0; index < length; index++) {
      final int current = index < currentParts.length ? currentParts[index] : 0;
      final int config = index < configParts.length ? configParts[index] : 0;
      if(current < config) return true;
      if(current > config) return false;
    }

    return false;
  }

  List<int> _versionParts(String version) {
    return version.split('.').map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0).toList();
  }
}
