import 'dart:async';
import 'dart:convert';

import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> login(String? email, String password) async {
    await Future.delayed(Duration(seconds: 3));
    
    return {
      'token' : "asfsdfsadfv235v454356345fsaef",
      'status_code' : 200,
    };
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    return await _postAuth(
      AppConstants.registationUri,
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _postAuth(
      AppConstants.forgetPaasswordUri,
      {
        'email': email,
      },
    );
  }

  Future<Map<String, dynamic>> _postAuth(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$path');
    final response = await http.post(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));

    final decodedBody = _decodeBody(response.body);
    return {
      ...decodedBody,
      'status_code': response.statusCode,
    };
  }

  Map<String, dynamic> _decodeBody(String body) {
    if(body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(body);
    if(decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {
      'message': decoded.toString(),
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
