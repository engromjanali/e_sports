class AuthLoginResult {
  final bool isSuccess;
  final String message;

  const AuthLoginResult(this.isSuccess, this.message);
}

abstract class AuthServiceInterface {
  Future<AuthLoginResult> login(String? email, String password);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearSharedData();

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
