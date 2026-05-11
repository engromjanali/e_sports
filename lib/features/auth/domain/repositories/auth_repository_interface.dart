abstract class AuthRepositoryInterface {
  Future<Map<String, dynamic>> login(String? email, String password);
  Future<Map<String, dynamic>> register(String name, String email, String password);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<bool> saveUserToken(String token);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearUserToken();
  Future<Map<String, dynamic>> verifyForgotPasswordOtp(String email, String otp);

  // Other auth flows are disabled for now.
  // Future<dynamic> updateToken();
  // Future<dynamic> getProfile();
}
