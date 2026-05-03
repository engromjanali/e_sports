import 'dart:async';

import '../repositories/auth_repository_interface.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<AuthLoginResult> login(String? email, String password) async {
    try {
      final response = await authRepositoryInterface.login(email, password);
      final statusCode = response['statusCode'];
      final token = _readToken(response);

      if((statusCode == 200 || statusCode == 201) && token != null) {
        await authRepositoryInterface.saveUserToken(token);
        return const AuthLoginResult(true, 'Login successful');
      }

      return AuthLoginResult(false, _readMessage(response, token));
    } on TimeoutException {
      return const AuthLoginResult(false, 'Request timeout. Please try again.');
    } catch (_) {
      return const AuthLoginResult(false, 'Login failed. Please try again.');
    }
  }

  String? _readToken(Map<String, dynamic> response) {
    final token = response['token'] ?? response['access_token'];
    if(token is String && token.isNotEmpty) {
      return token;
    }

    final data = response['data'];
    if(data is Map<String, dynamic>) {
      final dataToken = data['token'] ?? data['access_token'];
      if(dataToken is String && dataToken.isNotEmpty) {
        return dataToken;
      }
    }

    return null;
  }

  String _readMessage(Map<String, dynamic> response, String? token) {
    final message = response['message'] ?? response['error'];
    if(message != null) {
      return message.toString();
    }
    if(token == null && (response['statusCode'] == 200 || response['statusCode'] == 201)) {
      return 'Login token missing in response.';
    }
    return 'Invalid email or password.';
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepositoryInterface.clearSharedData();
  }

  // Other auth flows are disabled for now.
  // Future<dynamic> registerRestaurant(...);
  // Future<dynamic> updateToken();
  // Future<dynamic> forgotPassword(...);
  // Future<dynamic> getProfile();
}
