import 'package:e_sports/core/api/api_checker.dart';
import 'package:e_sports/core/data/models/auth_login_result_model.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';

import '../repositories/auth_repository_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<AuthLoginResult> login(String? email, String password, ) async {
    try {
      final Map<String, dynamic> response = await authRepositoryInterface.login(email, password);
      final token = _readToken(response);

      if (token == null) {
        return AuthLoginResult(false, _readMessage(response, fallback: 'Login token missing in response.'));
      }

      await authRepositoryInterface.saveUserToken(token);
      return const AuthLoginResult(true, 'Login successful');

    } on ValidationException catch (e) {
      return AuthLoginResult(false, "Invalid Email or Password!");

    } on UnauthorizedException catch (e) {
      // 401 on login = wrong credentials, NOT session expiry
      return AuthLoginResult(false, e.message);

    } on NetworkException catch (e) {
      return AuthLoginResult(false, e.message);

    } on ServerException catch (e) {
      // Don't expose raw server details to the user
      printer('[AuthService.login] ServerException ${e.statusCode}: ${e.message}');
      return const AuthLoginResult(false, 'Something went wrong. Please try again later.');

    } on AppException catch (e) {
      return AuthLoginResult(false, e.message);

    } catch (e) {
      printer('[AuthService.login] Unexpected: $e');
      return const AuthLoginResult(false, 'Login failed. Please try again.');
    }
  }

  @override
  Future<AuthLoginResult> register(String name, String email, String password) async {
    try {
      final Map<String, dynamic> response = await authRepositoryInterface.register(name, email, password);
      return AuthLoginResult(true, _readMessage(response, fallback: 'Registration successful. Please sign in.'));

    } on ValidationException catch (e) {
      return AuthLoginResult(false, e.message);

    } on NetworkException catch (e) {
      return AuthLoginResult(false, e.message);

    } on UnauthorizedException catch (_) {
      return AuthLoginResult(false, 'Session expired.');
    } on ServerException catch (e) {
      printer('[AuthService.register] ServerException ${e.statusCode}: ${e.message}');
      return const AuthLoginResult(false, 'Registration failed. Please try again later.');

    } on AppException catch (e) {
      return AuthLoginResult(false, e.message);

    } catch (e) {
      return const AuthLoginResult(false, 'Registration failed. Please try again.');
    }
  }

  @override
  Future<AuthLoginResult> forgotPassword(String email) async {
    try {
      final Map<String, dynamic> response = await authRepositoryInterface.forgotPassword(email);
      return AuthLoginResult(true, _readMessage(response, fallback: 'Password reset instructions sent.'));

    } on NetworkException catch (e) {
      return AuthLoginResult(false, e.message);

    } on AppException catch (e) {
      return AuthLoginResult(false, e.message);

    } catch (e) {
      return const AuthLoginResult(false, 'Unable to send reset instructions.');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String? _readToken(Map<String, dynamic> response) {
    final direct = response['token'] ?? response['access_token'];
    if (direct is String && direct.isNotEmpty) return direct;

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['token'] ?? data['access_token'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return null;
  }

  String _readMessage(Map<String, dynamic> response, {required String fallback}) {
    final msg = response['message'] ?? response['error'];
    if (msg is String && msg.isNotEmpty) return msg;
    return fallback;
  }

  @override
  String getUserToken() => authRepositoryInterface.getUserToken();

  @override
  bool isLoggedIn() => authRepositoryInterface.isLoggedIn();

  @override
  Future<bool> clearUserToken() async => authRepositoryInterface.clearUserToken();
  
  @override
  Future<AuthLoginResult> verifyForgotPasswordOtp(String email, String otp) async {
    try {
      final Map<String, dynamic> response = await authRepositoryInterface.verifyForgotPasswordOtp(email, otp);
      return AuthLoginResult(true, _readMessage(response, fallback: 'Otp verified successfully.'));
    } on NetworkException catch (e) {
      return AuthLoginResult(false, e.message);
    } on AppException catch (e) {
      return AuthLoginResult(false, e.message);
    } catch (e) {
      return const AuthLoginResult(false, 'Unable to verify otp.');
    }
  }
}



