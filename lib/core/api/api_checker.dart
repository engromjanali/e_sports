import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

// api_checker.dart — still used for global 401 on authenticated API calls
class ApiChecker {

  static void checkUnauthorized() async{
    // A 401 only means "session expired" if there was a session. During login
    // (no token yet) a 401 is just wrong credentials — don't force a redirect.
    if (!Get.find<AuthController>().isLoggedIn()) return;
    await Future.delayed(Duration(seconds: 2));
    Get.find<AuthController>().clearUserToken().then((_) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
    });
  }

}
