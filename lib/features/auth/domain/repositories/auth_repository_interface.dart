abstract class AuthRepositoryInterface {
  Future<Map<String, dynamic>> login(String? email, String password);
  Future<bool> saveUserToken(String token);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearSharedData();

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
