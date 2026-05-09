import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
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
      print('Token: $token');
    }

    updateHeader(token);
  }

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

  Map<String, String> getHeader() => _mainHeaders;

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers, bool handleError = true,}) async {
    try {
      if (kDebugMode) {
        log('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      }
      http.Response response = await http.get(Uri.parse(appBaseUrl + uri), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      if (kDebugMode) {
        print('------------${e.toString()}');
      }
      throw NetworkException(noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers, int? timeout, bool handleError = true,}) async {
    
    http.Response response;
    
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body');
      }

      response = await http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeout ?? timeoutInSeconds)
      );
    } catch (e) {
      print("----> error: $e ");
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
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint(
        '====> API Body: $body with ${multipartBody.length} and multipart ${multipartDoc?.length}',
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
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, uri, handleError);
    } catch (e) {
      throw NetworkException(noInternetMessage);
    }
  }

  Future<Response> putData(
    String uri,
    dynamic body, {Map<String, String>? headers, bool handleError = true}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body');
      }
      http.Response response = await http.put(Uri.parse(appBaseUrl + uri), body: jsonEncode(body), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      throw NetworkException(noInternetMessage);
    }
  }

  Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
    bool handleError = true,
  }) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      }
      http.Response response = await http
          .delete(Uri.parse(appBaseUrl + uri), headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      throw NetworkException(noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri, bool handleError) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}

    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: response.request!.headers,
        method: response.request!.method,
        url: response.request!.url,
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (kDebugMode) {
      log('====> API Response: [${response0.statusCode}] $uri');
      log('====> API Response Body: ${response0.body}');
    }

    // Extract a clean message from whatever shape the body is
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

    // ── Throw typed exceptions based on status code ────────────────────────
    switch (response.statusCode) {
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
        throw UnauthorizedException(
          _extractMessage(response0, 'Unauthorized. Please login again.'),
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
