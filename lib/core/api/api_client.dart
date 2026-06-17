import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_sports/core/api/api_checker.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/widgets/custom_snackbar.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 40;

  String? token;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    if (kDebugMode) {
      printer('Token: $token');
    }

    updateHeader(token);
  }

  Map<String, String> getHeader() => _mainHeaders;

  Map<String, String> updateHeader(String? token) {
    Map<String, String> header = {};

    header.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    
    _mainHeaders = header;

    return header;
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers, bool handleError = true,}) async {
    http.Response response;
    try {
      if (kDebugMode) {
        log('====> API Call[get]: $uri\nHeader: ${headers ?? _mainHeaders}');
      }
      response = await http.get(Uri.parse(appBaseUrl + uri), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
    } catch (e) {
      if (kDebugMode) log('====> API Error [get]: $uri\n$e');
      throw NetworkException(noInternetMessage);
    }
    return handleResponse(response, uri, handleError);
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers, int? timeout, bool handleError = true,}) async {
    http.Response response;
    try {
      if (kDebugMode) {
        printer('====> API Call [post]: $uri\nHeader: ${headers ?? _mainHeaders}');
        printer('====> API Body [post]: $body');
      }

      response = await http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeout ?? timeoutInSeconds)
      );
    } catch (e) {
      if (kDebugMode) log('====> API Error [post]: $uri\n$e');
      throw NetworkException(noInternetMessage);
    }
    return handleResponse(response, uri, handleError);
  }

  Future<Response> postMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    List<MultipartDocument>? multipartDoc,
    Map<String, String>? headers,
    bool handleError = true,
  }) async {
    http.Response response;
    try {
      printer('====> API Call [post-multipart]: $uri\nHeader: $_mainHeaders');
      printer(
        '====> API Body [post-multipart]: $body with ${multipartBody.length} and multipart ${multipartDoc?.length}',
      );
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(appBaseUrl + uri),
      );
      final Map<String, String> multipartHeaders = Map<String, String>.from(headers ?? _mainHeaders);
      multipartHeaders.removeWhere((key, value) => key.toLowerCase() == 'content-type');
      request.headers.addAll(multipartHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (kIsWeb) {
            Uint8List bytes = await multipart.file!.readAsBytes();

            http.MultipartFile part = http.MultipartFile.fromBytes(multipart.key, bytes, filename: 'image.jpg', contentType: MediaType('image', 'jpeg'));

            request.files.add(part);
          } else {
            File file = File(multipart.file!.path);
            request.files.add(
              http.MultipartFile(multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last),
            );
          }
        }
      }

      if (multipartDoc != null && multipartDoc.isNotEmpty) {
        for (MultipartDocument file in multipartDoc) {
          if (kIsWeb) {
            PlatformFile platformFile = file.file!.files.first;
            request.files.add(
              http.MultipartFile.fromBytes(file.key, platformFile.bytes!, filename: platformFile.name),
            );
          } else {
            File other = File(file.file!.files.single.path!);
            Uint8List list0 = await other.readAsBytes();
            var part = http.MultipartFile(file.key, other.readAsBytes().asStream(), list0.length, filename: basename(other.path));
            request.files.add(part);
          }
        }
      }

      request.fields.addAll(body);
      response = await http.Response.fromStream(await request.send());
    } catch (e) {
      if (kDebugMode) log('====> API Error: $uri\n$e');
      throw NetworkException(noInternetMessage);
    }
    return handleResponse(response, uri, handleError);
  }

  Future<Response> putData(
    String uri,
    dynamic body, {Map<String, String>? headers, bool handleError = true}) async {
    http.Response response;
    try {
      if (kDebugMode) {
        printer('====> API Call [put]: $uri\nHeader: ${headers ?? _mainHeaders}');
        printer('====> API Body [put]: $body');
      }
      response = await http.put(Uri.parse(appBaseUrl + uri), body: jsonEncode(body), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
    } catch (e) {
      if (kDebugMode) log('====> API Error: $uri\n$e');
      throw NetworkException(noInternetMessage);
    }
    return handleResponse(response, uri, handleError);
  }

  Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
    bool handleError = true,
  }) async {
    http.Response response;
    try {
      if (kDebugMode) {
        printer('====> API Call [delete]: $uri\nHeader: ${headers ?? _mainHeaders}');
      }
      response = await http
          .delete(Uri.parse(appBaseUrl + uri), headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
    } catch (e) {
      if (kDebugMode) log('====> API Error: $uri\n$e');
      throw NetworkException(noInternetMessage);
    }
    return handleResponse(response, uri, handleError);
  }

  String _extractMessage(Response r, String fallback) {
    final b = r.body;
    if (b is Map) {
      return b['message']?.toString() ??
          b['error']?.toString() ??
          (b['errors'] is List ? (b['errors'] as List).first['message']?.toString() : null) ??
          fallback;
    }
    return r.statusText ?? fallback;
  }

  Response handleResponse(http.Response response, String uri, bool handleError) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}

    
      
    final request = response.request;

    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: request?.headers ?? {},
        method: request?.method ?? 'GET',
        url: request?.url ?? Uri.parse(appBaseUrl + uri),
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (kDebugMode) {
      log('====> API Response : [${response0.statusCode}] $uri');
      log('====> API Response Body: ${response0.body}');
    }

    // ── Throw typed exceptions based on status code ────────────────────────
    try {
      switch (response.statusCode) {
        case 1:
          throw NetworkException(_extractMessage(response0, noInternetMessage));

        case 200:
        case 201:
          return response0;

        case 400:
          final errors = (body?['errors'] as Map?)?.cast<String, String>();
          throw ValidationException(
            _extractMessage(response0, 'Invalid request.'),
            fieldErrors: errors,
          );

        case 401:
          ApiChecker.checkUnauthorized();
          throw UnauthorizedException(
            _extractMessage(response0, 'Session expaired!, please login again.'),
          );

        case 404:
          throw NotFoundException(
            _extractMessage(response0, 'Resource not found.'),
          );

        default:
          if (response.statusCode >= 500) {
            throw ServerException(
              _extractMessage(response0, 'Server error. Please try again later.'),
              response.statusCode,
            );
          }
          throw ServerException(
            _extractMessage(response0, 'Unexpected error occurred.'),
            response.statusCode,
          );
      }
    } catch (e) {
      if(handleError && e is AppException){
        showCustomSnackBar(e.message);
        return Response(statusCode: response.statusCode, statusText: e.message);
      }
      else if (handleError){
        showCustomSnackBar('Something went wrong');
        return Response(statusCode: response.statusCode, statusText: 'Something went wrong');
      }
      rethrow;
    }
  }
}

class MultipartBody {
  String key;
  XFile? file;

  MultipartBody(this.key, this.file);
}

class MultipartDocument {
  String key;
  FilePickerResult? file;
  MultipartDocument(this.key, this.file);
}
