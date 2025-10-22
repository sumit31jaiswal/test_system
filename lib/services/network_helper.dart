import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_package;

import 'api_url.dart';

class NetworkHelper {
  Dio? dio;

  NetworkHelper() {
    if (dio == null) {
      final BaseOptions options = BaseOptions(
        baseUrl: APIUrl.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {"Connection": "Keep-Alive"},
      );
      dio = Dio(options);
    }
  }

  Future<Response?> getWithParams({
    required String url,
    Map<String, dynamic>? parameterMap,
    Map<String, dynamic>? body,
  }) async {
    return _performRequest(
      () async => dio?.get(url, queryParameters: parameterMap, data: body),
      methodName: "GET",
      url: url,
      body: body ?? parameterMap,
    );
  }

  Future<Response?> postWithBody({required String url, dynamic body}) async {
    return _performRequest(
      () => dio!.post(url, data: body),
      methodName: "POST",
      url: url,
      body: body,
    );
  }

  Future<Response?> deleteWithBody({required String url, dynamic body}) async {
    return _performRequest(
      () => dio!.delete(url, data: body),
      methodName: "DELETE",
      url: url,
      body: body,
    );
  }

  Future<Response?> putWithBody({required String url, dynamic body}) async {
    return _performRequest(
      () => dio!.put(url, data: body),
      methodName: "PUT",
      url: url,
      body: body,
    );
  }

  Future<Response?> _performRequest(
    Future<Response?> Function() requestFn, {
    required String methodName,
    required String url,
    dynamic body,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await requestFn();
      log("✅ $methodName: ${response?.realUri}");
      log("📦 Request Body: $body");
      log("🕐 Response time: ${stopwatch.elapsed}");
      log("📥 Response: ${response?.data}");

      return response;
    } on DioException catch (e) {
      await _handleError(e, methodName, url, body);
      return e.response;
    } on SocketException {
      showErrorNotification(
        "Server Unreachable",
        "Check your internet connection or try again later.",
        isNetworkError: true,
      );
      return null;
    } catch (e) {
      showErrorNotification("Unexpected Error", e.toString());
      return null;
    }
  }

  Future<void> _handleError(
    DioException error,
    String method,
    String url,
    dynamic body,
  ) async {
    log("🔥 DioException in $method: ${error.message}");
    log("🔥 DioException in $method: ${error.type}");

    log("🔥 URL: $url\n🔥 Body: $body");

    final code = error.response?.statusCode;
    final message = error.message ?? '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        showErrorNotification(
          "Timeout",
          "The server is not responding. Please try again later.",
          isNetworkError: true,
        );
        break;
      case DioExceptionType.badResponse:
        _handleHttpError(code, message);
        break;
      case DioExceptionType.unknown:
        showErrorNotification(
          "Network Error",
          "Please check your internet connection.",
          isNetworkError: true,
        );
        break;
      case DioExceptionType.connectionError:
        showErrorNotification(
          "Network Error",
          "Please check your internet connection.",
          isNetworkError: true,
        );
        break;
      default:
        showErrorNotification(
          "Error",
          message.isNotEmpty ? message : "An unexpected error occurred.",
        );
        break;
    }
  }

  void _handleHttpError(int? code, String message) {
    switch (code) {
      case 400:
        showErrorNotification("Bad Request", message);
        break;
      case 401:
        showErrorNotification(
          "Unauthorized",
          message.isNotEmpty
              ? message
              : "Session expired. Please log in again.",
        );
        break;
      case 403:
        showErrorNotification("Forbidden", message);
        break;
      case 404:
        showErrorNotification("Not Found", message);
        break;
      case 405:
        showErrorNotification("Method Not Allowed", message);
        break;
      case 409:
        showErrorNotification("Conflict", message);
        break;
      case 500:
      case 503:
        showErrorNotification(
          "Server Error",
          "Something went wrong on the server. Try again later.",
        );
        break;
      default:
        showErrorNotification("Error", message);
    }
  }

  static bool _isNetworkErrorShown = false;

  // ============== SNACKBAR ==============
  void showErrorNotification(
    String title,
    String message, {
    bool isNetworkError = false,
  }) {
    if (isNetworkError) {
      if (_isNetworkErrorShown) return;
      _isNetworkErrorShown = true;
      Future.delayed(const Duration(seconds: 5), () {
        _isNetworkErrorShown = false;
      });
    }

    get_package.Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      snackPosition: get_package.SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      colorText: Colors.black,
    );
  }
}
