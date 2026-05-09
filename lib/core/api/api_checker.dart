import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/widgets/custom_snackbar.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

// api_checker.dart — still used for global 401 on authenticated API calls
class ApiChecker {
  static void checkUnauthorized() {
    Get.find<AuthController>().clearUserToken().then((_) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
    });
  }
}