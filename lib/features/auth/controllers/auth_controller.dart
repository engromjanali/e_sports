import 'package:get/get.dart';
import 'package:e_sports/core/data/models/auth_login_result_model.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<AuthLoginResult> login(String? email, String password) async {
    _isLoading = true;
    update();
    final AuthLoginResult responseModel = await authServiceInterface.login(email, password);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<AuthLoginResult> register(String name, String email, String password) async {
    _isLoading = true;
    update();
    final AuthLoginResult responseModel = await authServiceInterface.register(name, email, password);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<AuthLoginResult> forgotPassword(String email) async {
    _isLoading = true;
    update();
    final AuthLoginResult responseModel = await authServiceInterface.forgotPassword(email);
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

  Future<bool> clearUserToken() async {
    return await authServiceInterface.clearUserToken();
  }

  Future<AuthLoginResult> verifyForgotPasswordOtp(String email, String otp) async {
    _isLoading = true;
    update();
    final AuthLoginResult responseModel = await authServiceInterface.verifyForgotPasswordOtp(email, otp);
    _isLoading = false;
    update();
    return responseModel;
  }

  // Other auth flows are disabled for now.
  // void pickImageForReg(...);
  // Future<void> updateToken();
  // Future<void> toggleStoreClosedStatus();
}
