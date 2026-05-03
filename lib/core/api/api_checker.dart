import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/widgets/custom_snackbar.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearUserToken().then((value) {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      });
    }else {
      if(response.statusText != 'The guest id field is required.') {
        showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
      }
    }
  }
}
