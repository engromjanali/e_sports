abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection. Please check your network.']);
}

class ServerException extends AppException {
  final int statusCode;
  const ServerException(super.message, this.statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired. Please login again.']);
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  const ValidationException(super.message, {this.fieldErrors});
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.']);
}