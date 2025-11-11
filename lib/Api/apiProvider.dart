import 'dart:convert';

import 'package:carwash/ModelClass/Authentication/postLoginModel.dart';
import 'package:carwash/ModelClass/Customer/getAllCustomerModel.dart';
import 'package:carwash/ModelClass/Customer/getCustomerByIdModel.dart';
import 'package:carwash/ModelClass/Customer/getVehicleByCustomerModel.dart';
import 'package:carwash/ModelClass/Customer/postCustomerModel.dart';
import 'package:carwash/ModelClass/Customer/updateCustomerModel.dart';
import 'package:carwash/ModelClass/JobCard/getAllJobCardModel.dart';
import 'package:carwash/ModelClass/ShopDetails/getShopDetailsModel.dart';
import 'package:carwash/ModelClass/Vehicle/getAllVehiclesModel.dart';
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

  ///  Authentication
  /// LoginOTP API Integration
  Future<PostLoginModel> loginAPI(String email, String password) async {
    try {
      final dataMap = {"email": email, "password": password};
      var dio = Dio();
      final response = await dio.post(
        '${Constants.baseUrl}auth/signin'.trim(),
        data: json.encode(dataMap),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          final postLoginResponse = PostLoginModel.fromJson(response.data);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString("token", postLoginResponse.token.toString());
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
      if (response.statusCode == 401 && response.data != null) {
        return PostLoginModel()
          ..errorResponse = ErrorResponse(
            message: response.data['message'] ?? "Invalid credentials.",
          );
      }
      if (response.statusCode == 500 && response.data != null) {
        return PostLoginModel()
          ..errorResponse = ErrorResponse(
            message: response.data['message'] ?? "Invalid credentials.",
          );
      }
      return PostLoginModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return PostLoginModel()..errorResponse = errorResponse;
    } catch (error) {
      return PostLoginModel()..errorResponse = handleError(error);
    }
  }

  /// shop Details
  /// shop details - API Integration
  Future<GetShopDetailsModel> getShopDetailsAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}shop/details',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetShopDetailsModel getShopDetailsResponse =
              GetShopDetailsModel.fromJson(response.data);
          return getShopDetailsResponse;
        }
      } else {
        return GetShopDetailsModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetShopDetailsModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetShopDetailsModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetShopDetailsModel()..errorResponse = errorResponse;
    }
  }

  /// Customer
  /// Customer List - API Integration
  Future<GetAllCustomerModel> getAllCustomerAPI(
    String? searchKey,
    String? offset,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}customers?search=$searchKey&offset=$offset&limit=10',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetAllCustomerModel getAllCustomerResponse =
              GetAllCustomerModel.fromJson(response.data);
          return getAllCustomerResponse;
        }
      } else {
        return GetAllCustomerModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetAllCustomerModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetAllCustomerModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetAllCustomerModel()..errorResponse = errorResponse;
    }
  }

  /// Create Customer - API Integration
  Future<PostCustomerModel> postCustomerAPI(
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    bool? active,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      final dataMap = {
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "email": email,
        "address": address,
        "isActive": active,
      };
      var data = json.encode(dataMap);
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}customers',
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: data,
      );
      if (response.statusCode == 201 && response.data != null) {
        if (response.data['success'] == true) {
          PostCustomerModel postCustomerResponse = PostCustomerModel.fromJson(
            response.data,
          );
          return postCustomerResponse;
        }
      } else {
        return PostCustomerModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return PostCustomerModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return PostCustomerModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return PostCustomerModel()..errorResponse = errorResponse;
    }
  }

  /// Customer List by id - API Integration
  Future<GetCustomerByIdModel> getCustomerByIdAPI(String? cusId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}customers/$cusId',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetCustomerByIdModel getCustomerByIdResponse =
              GetCustomerByIdModel.fromJson(response.data);
          return getCustomerByIdResponse;
        }
      } else {
        return GetCustomerByIdModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetCustomerByIdModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetCustomerByIdModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetCustomerByIdModel()..errorResponse = errorResponse;
    }
  }

  /// Edit Customer - API Integration
  Future<UpdateCustomerModel> updateCustomerAPI(
    String? cusId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    bool? active,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      final dataMap = {
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "email": email,
        "address": address,
        "isActive": active,
      };
      var data = json.encode(dataMap);
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}customers/$cusId',
        options: Options(
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: data,
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          UpdateCustomerModel updateCustomerResponse =
              UpdateCustomerModel.fromJson(response.data);
          return updateCustomerResponse;
        }
      } else {
        return UpdateCustomerModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return UpdateCustomerModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return UpdateCustomerModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return UpdateCustomerModel()..errorResponse = errorResponse;
    }
  }

  /// Customer Vehicle - API Integration
  Future<GetVehicleByCustomerModel> getVehicleByCustomerAPI(
    String? cusId,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}vehicles/customer/$cusId',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetVehicleByCustomerModel getVehicleByCustomerResponse =
              GetVehicleByCustomerModel.fromJson(response.data);
          return getVehicleByCustomerResponse;
        }
      } else {
        return GetVehicleByCustomerModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetVehicleByCustomerModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetVehicleByCustomerModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetVehicleByCustomerModel()..errorResponse = errorResponse;
    }
  }

  /// Job Cards
  /// JobCard API Integration
  Future<GetAllJobCardModel> getAllJobCardAPI(
    String? searchKey,
    String? offset,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}jobcards/list?search=$searchKey&offset=$offset&limit=10',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetAllJobCardModel getAllJobCardResponse =
              GetAllJobCardModel.fromJson(response.data);
          return getAllJobCardResponse;
        }
      } else {
        return GetAllJobCardModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetAllJobCardModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetAllJobCardModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetAllJobCardModel()..errorResponse = errorResponse;
    }
  }

  /// Vehicles
  /// Vehicles API Integration
  Future<GetAllVehiclesModel> getAllVehicleAPI(
    String? searchKey,
    String? offset,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      debugPrint(
        "URL: ${Constants.baseUrl}vehicles?search=$searchKey&offset=$offset&limit=10",
      );
      var response = await dio.request(
        '${Constants.baseUrl}vehicles?search=$searchKey&offset=$offset&limit=10',
        options: Options(
          method: 'GET',
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetAllVehiclesModel getAllVehiclesResponse =
              GetAllVehiclesModel.fromJson(response.data);
          return getAllVehiclesResponse;
        }
      } else {
        return GetAllVehiclesModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetAllVehiclesModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetAllVehiclesModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetAllVehiclesModel()..errorResponse = errorResponse;
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
