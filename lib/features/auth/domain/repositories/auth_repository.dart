import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> login(String? email, String password) async {
    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.loginUri}');

    await Future.delayed(Duration(seconds: 3));
    
    return {
      'token' : "asfsdfsadfv235v454356345fsaef",
      'status_code' : 200,
    };
  }

  @override
  Future<bool> saveUserToken(String token) async {
    return await sharedPreferences.setString(AppConstants.authToken, token);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.authToken) ?? '';
  }

  @override
  bool isLoggedIn() {
    return getUserToken().isNotEmpty;
  }

  @override
  Future<bool> clearUserToken() async {
    return await sharedPreferences.remove(AppConstants.authToken);
  }

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
