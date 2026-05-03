
import 'package:e_sports/core/data/models/auth_login_result_model.dart';

abstract class AuthServiceInterface {
  Future<AuthLoginResult> login(String? email, String password);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearUserToken();

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
