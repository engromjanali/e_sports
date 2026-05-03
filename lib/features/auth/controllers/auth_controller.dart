import 'package:get/get.dart';
import 'package:e_sports/core/data/models/auth_login_result_model.dart';

import '../domain/services/auth_service_interface.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<AuthLoginResult> login(String? email, String password) async {
    _isLoading = true;
    update();
    final responseModel = await authServiceInterface.login(email, password);
    _isLoading = false;
    update();
    return responseModel;
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<bool> clearSharedData() async {
    return await authServiceInterface.clearUserToken();
  }

  // Other auth flows are disabled for now.
  // void pickImageForReg(...);
  // Future<void> updateToken();
  // Future<void> registerStore(...);
  // Future<void> toggleStoreClosedStatus();
}
