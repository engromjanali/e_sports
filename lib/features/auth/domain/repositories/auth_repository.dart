import 'dart:convert';

import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> login(String? email, String password) async {
    return await _postAuth(
      AppConstants.loginUri,
      {
        'email': email,
        'password': password,
      },
    );
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
    final Response response = await apiClient.postData(path, body, handleError: false);
    final decodedBody = _decodeBody(response.body);
    return {
      ...decodedBody,
      'status_code': response.statusCode,
    };
  }

  Map<String, dynamic> _decodeBody(dynamic body) {
    if(body == null) {
      return {};
    }

    if(body is Map<String, dynamic>) {
      return body;
    }
    if(body is Map) {
      return Map<String, dynamic>.from(body);
    }

    if(body is String && body.isNotEmpty) {
      dynamic decoded;
      try {
        decoded = jsonDecode(body);
      } catch (_) {
        return {
          'message': body,
        };
      }
      if(decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {
        'message': decoded.toString(),
      };
    }

    return {
      'message': body.toString(),
    };
  }

  @override
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? '';
  }

  @override
  bool isLoggedIn() {
    return getUserToken().isNotEmpty;
  }

  @override
  Future<bool> clearUserToken() async {
    apiClient.token = null;
    apiClient.updateHeader(null);
    return await sharedPreferences.remove(AppConstants.token);
  }

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
