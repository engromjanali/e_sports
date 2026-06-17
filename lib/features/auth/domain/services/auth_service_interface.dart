import 'package:e_sports/core/data/models/auth_login_result_model.dart';

abstract class AuthServiceInterface {
  Future<AuthLoginResult> login(String email, String password);
  Future<AuthLoginResult> register(String name, String email, String password);
  Future<AuthLoginResult> forgotPassword(String email);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearUserToken();
  Future<AuthLoginResult> verifyForgotPasswordOtp(String email, String otp);

  // Other auth flows are disabled for now.
  // Future<dynamic> updateToken();
  // Future<dynamic> getProfile();
}
