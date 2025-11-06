import 'dart:convert';

import 'package:carwash/ModelClass/Authentication/postLoginModel.dart';
import 'package:carwash/Reusable/constant.dart';
import 'package:dio/dio.dart';
import 'package:carwash/Bloc/Response/errorResponse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All API Integration in ApiProvider
class ApiProvider {
  late Dio _dio;

  /// dio use ApiProvider
  ApiProvider() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    );
    _dio = Dio(options);
  }

  /// LoginWithOTP API Integration
  Future<PostLoginModel> loginAPI(String email, String password) async {
    try {
      final dataMap = {"email": email, "password": password};
      var dio = Dio();
      final response = await dio.post(
        '${Constants.baseUrl}auth/signin'.trim(),
        data: json.encode(dataMap),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      debugPrint("🟢 RESPONSE CODE: ${response.statusCode}");
      debugPrint("🟢 RESPONSE DATA: ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        // ✅ Login success
        if (response.data['success'] == true) {
          final postLoginResponse = PostLoginModel.fromJson(response.data);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
            "firstName",
            postLoginResponse.user!.firstName.toString(),
          );
          prefs.setString(
            "lastName",
            postLoginResponse.user!.lastName.toString(),
          );
          prefs.setString("role", postLoginResponse.user!.roleCode.toString());
          prefs.setString("userId", postLoginResponse.user!.id.toString());

          return postLoginResponse;
        } else {
          // ✅ success = false → show backend message
          return PostLoginModel()
            ..errorResponse = ErrorResponse(
              message: response.data['message'] ?? "Login failed.",
            );
        }
      }

      // ✅ Handle unauthorized (401) or other errors with message
      if (response.statusCode == 401 && response.data != null) {
        return PostLoginModel()
          ..errorResponse = ErrorResponse(
            message: response.data['message'] ?? "Invalid credentials.",
          );
      }
      //✅ Handle unauthorized (500) or other errors with message
      if (response.statusCode == 500 && response.data != null) {
        return PostLoginModel()
          ..errorResponse = ErrorResponse(
            message: response.data['message'] ?? "Invalid credentials.",
          );
      }
      // ✅ Unexpected
      return PostLoginModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } on DioException catch (dioError) {
      // debugPrint("🔴 DIO ERROR TYPE: ${dioError.type}");
      // debugPrint("🔴 DIO ERROR MESSAGE: ${dioError.message}");
      final errorResponse = handleError(dioError);
      return PostLoginModel()..errorResponse = errorResponse;
    } catch (error) {
      // debugPrint("🔴 GENERAL ERROR: $error");
      return PostLoginModel()..errorResponse = handleError(error);
    }
  }

  /// handle Error Response
  ErrorResponse handleError(Object error) {
    ErrorResponse errorResponse = ErrorResponse();
    Errors errorDescription = Errors();

    if (error is DioException) {
      DioException dioException = error;

      switch (dioException.type) {
        case DioExceptionType.cancel:
          errorDescription.code = "0";
          errorDescription.message = "Request Cancelled";
          errorResponse.statusCode = 0;
          break;

        case DioExceptionType.connectionTimeout:
          errorDescription.code = "522";
          errorDescription.message = "Connection Timeout";
          errorResponse.statusCode = 522;
          break;

        case DioExceptionType.sendTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Send Timeout";
          errorResponse.statusCode = 408;
          break;

        case DioExceptionType.receiveTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Receive Timeout";
          errorResponse.statusCode = 408;
          break;

        case DioExceptionType.badResponse:
          if (dioException.response != null) {
            final statusCode = dioException.response!.statusCode!;
            errorDescription.code = statusCode.toString();
            errorResponse.statusCode = statusCode;

            if (statusCode == 401) {
              try {
                final message =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["error"] ??
                    dioException.response!.data["errors"]?[0]?["message"];

                if (message != null &&
                    (message.toLowerCase().contains("token") ||
                        message.toLowerCase().contains("expired"))) {
                  errorDescription.message =
                      "Session expired. Please login again.";
                  errorResponse.message =
                      "Session expired. Please login again.";
                } else if (message != null &&
                    (message.toLowerCase().contains("invalid credentials") ||
                        message.toLowerCase().contains("unauthorized") ||
                        message.toLowerCase().contains("incorrect"))) {
                  errorDescription.message =
                      "Invalid credentials. Please try again.";
                  errorResponse.message =
                      "Invalid credentials. Please try again.";
                } else {
                  errorDescription.message = message;
                  errorResponse.message = message;
                }
              } catch (_) {
                errorDescription.message = "Unauthorized access";
                errorResponse.message = "Unauthorized access";
              }
            } else if (statusCode == 403) {
              errorDescription.message = "Access forbidden";
              errorResponse.message = "Access forbidden";
            } else if (statusCode == 404) {
              errorDescription.message = "Resource not found";
              errorResponse.message = "Resource not found";
            } else if (statusCode == 500) {
              errorDescription.message = "Internal Server Error";
              errorResponse.message = "Internal Server Error";
            } else if (statusCode >= 400 && statusCode < 500) {
              // Client errors - try to get API message
              try {
                final apiMessage =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["errors"]?[0]?["message"];
                errorDescription.message =
                    apiMessage ?? "Client error occurred";
                errorResponse.message = apiMessage ?? "Client error occurred";
              } catch (_) {
                errorDescription.message = "Client error occurred";
                errorResponse.message = "Client error occurred";
              }
            } else if (statusCode >= 500) {
              // Server errors
              errorDescription.message = "Server error occurred";
              errorResponse.message = "Server error occurred";
            } else {
              // Other status codes - fallback to API-provided message
              try {
                final message =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["errors"]?[0]?["message"];
                errorDescription.message = message ?? "Something went wrong";
                errorResponse.message = message ?? "Something went wrong";
              } catch (_) {
                errorDescription.message = "Unexpected error response";
                errorResponse.message = "Unexpected error response";
              }
            }
          } else {
            errorDescription.code = "500";
            errorDescription.message = "Internal Server Error";
            errorResponse.statusCode = 500;
            errorResponse.message = "Internal Server Error";
          }
          break;

        case DioExceptionType.unknown:
          errorDescription.code = "500";
          errorDescription.message = "Unknown error occurred";
          errorResponse.statusCode = 500;
          errorResponse.message = "Unknown error occurred";
          break;

        case DioExceptionType.badCertificate:
          errorDescription.code = "495";
          errorDescription.message = "Bad SSL Certificate";
          errorResponse.statusCode = 495;
          errorResponse.message = "Bad SSL Certificate";
          break;

        case DioExceptionType.connectionError:
          errorDescription.code = "500";
          errorDescription.message = "Connection error occurred";
          errorResponse.statusCode = 500;
          errorResponse.message = "Connection error occurred";
          break;
      }
    } else {
      errorDescription.code = "500";
      errorDescription.message = "An unexpected error occurred";
      errorResponse.statusCode = 500;
      errorResponse.message = "An unexpected error occurred";
    }

    errorResponse.errors = [errorDescription];
    return errorResponse;
  }
}
