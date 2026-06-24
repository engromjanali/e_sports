import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class AppHelper {
  static final AppHelper _instance = AppHelper._();

  factory AppHelper() => _instance;

  static int get season {
    try {
      return Get.find<SplashController>().configModel?.currentSeason ?? AppConstants.currentSeason;
    } catch (_) {
      return AppConstants.currentSeason;
    }
  }

  AppHelper._();
}