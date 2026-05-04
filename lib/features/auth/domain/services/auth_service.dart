import 'dart:async';
import 'package:e_sports/core/data/models/auth_login_result_model.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<AuthLoginResult> login(String? email, String password) async {
    try {
      final response = await authRepositoryInterface.login(email, password);
      final statusCode = _readStatusCode(response);
      final token = _readToken(response);

      if((statusCode == 200 || statusCode == 201) && token != null) {
        await authRepositoryInterface.saveUserToken(token);
        return const AuthLoginResult(true, 'Login successful');
      }

      return AuthLoginResult(false, _readMessage(response, token, needsToken: true));
    } on TimeoutException {
      return const AuthLoginResult(false, 'Request timeout. Please try again.');
    } catch (_) {
      return const AuthLoginResult(false, 'Login failed. Please try again.');
    }
  }

  @override
  Future<AuthLoginResult> register(String name, String email, String password) async {
    try {
      final response = await authRepositoryInterface.register(name, email, password);
      final statusCode = _readStatusCode(response);

      if(statusCode == 200 || statusCode == 201) {
        return AuthLoginResult(true, _readMessage(response, null, fallback: 'Registration successful. Please sign in.'));
      }

      return AuthLoginResult(false, _readMessage(response, null, fallback: 'Registration failed. Please try again.'));
    } on TimeoutException {
      return const AuthLoginResult(false, 'Request timeout. Please try again.');
    } catch (_) {
      return const AuthLoginResult(false, 'Registration failed. Please try again.');
    }
  }

  @override
  Future<AuthLoginResult> forgotPassword(String email) async {
    try {
      final response = await authRepositoryInterface.forgotPassword(email);
      final statusCode = _readStatusCode(response);

      if(statusCode == 200 || statusCode == 201) {
        return AuthLoginResult(true, _readMessage(response, null, fallback: 'Password reset instructions sent to your email.'));
      }

      return AuthLoginResult(false, _readMessage(response, null, fallback: 'Unable to send reset instructions.'));
    } on TimeoutException {
      return const AuthLoginResult(false, 'Request timeout. Please try again.');
    } catch (_) {
      return const AuthLoginResult(false, 'Unable to send reset instructions.');
    }
  }

  int? _readStatusCode(Map<String, dynamic> response) {
    final statusCode = response['status_code'] ?? response['statusCode'];
    if(statusCode is int) {
      return statusCode;
    }
    return int.tryParse(statusCode.toString());
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

  String _readMessage(Map<String, dynamic> response, String? token, {String fallback = 'Invalid email or password.', bool needsToken = false}) {
    final message = response['message'] ?? response['error'];
    if(message != null) {
      return message.toString();
    }
    final statusCode = _readStatusCode(response);
    if(needsToken && token == null && (statusCode == 200 || statusCode == 201)) {
      return 'Login token missing in response.';
    }
    return fallback;
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
  Future<bool> clearUserToken() async {
    return await authRepositoryInterface.clearUserToken();
  }

  // Other auth flows are disabled for now.
  // Future<dynamic> updateToken();
  // Future<dynamic> getProfile();
}
