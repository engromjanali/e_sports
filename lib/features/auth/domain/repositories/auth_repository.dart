import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> login(String? email, String password) async {
    return {
      'token' : "0a18b0e5-770d-41b1-92b2-7005a1418816"
    };
    
    // ApiClient throws AppException on failure — no try/catch here
    final response = await apiClient.postData(
      AppConstants.loginUri,
      {'email': email, 'password': password},
      handleError: false
    );
    return response.body as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await apiClient.postData(
      AppConstants.registationUri,
      {'name': name, 'email': email, 'password': password},
    );
    return response.body as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await apiClient.postData(
      AppConstants.forgetPaasswordUri,
      {'email': email},
    );
    return response.body as Map<String, dynamic>;
  }

  @override
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  String getUserToken() => sharedPreferences.getString(AppConstants.token) ?? '';

  @override
  bool isLoggedIn() => getUserToken().isNotEmpty;

  @override
  Future<bool> clearUserToken() async {
    apiClient.token = null;
    apiClient.updateHeader(null);
    return await sharedPreferences.remove(AppConstants.token);
  }

  @override
  Future<Map<String, dynamic>> verifyForgotPasswordOtp(String email, String otp) async {
    final Response response = await apiClient.postData(
      AppConstants.verifyForgetPasswordOtpUri,
      {'email': email, 'otp': otp},
    );
    return response.body;
  }
}