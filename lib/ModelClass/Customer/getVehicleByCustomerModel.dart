import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Vehicles fetched successfully"
/// result : [{"id":"6395fe3c-a10b-4022-8349-117bc5515a66","registrationNumber":"TN76BY8986","make":"Swift","model":"ZXI","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d"}]

class GetVehicleByCustomerModel {
  GetVehicleByCustomerModel({
    bool? success,
    String? message,
    List<Result>? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetVehicleByCustomerModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result?.add(Result.fromJson(v));
      });
    }
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  String? _message;
  List<Result>? _result;
  ErrorResponse? errorResponse;
  GetVehicleByCustomerModel copyWith({
    bool? success,
    String? message,
    List<Result>? result,
  }) => GetVehicleByCustomerModel(
    success: success ?? _success,
    message: message ?? _message,
    result: result ?? _result,
  );
  bool? get success => _success;
  String? get message => _message;
  List<Result>? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_result != null) {
      map['result'] = _result?.map((v) => v.toJson()).toList();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// id : "6395fe3c-a10b-4022-8349-117bc5515a66"
/// registrationNumber : "TN76BY8986"
/// make : "Swift"
/// model : "ZXI"
/// customerId : "cec28d95-0c91-4c0b-abde-f338c62c220d"

class Result {
  Result({
    String? id,
    String? registrationNumber,
    String? make,
    String? model,
    String? customerId,
  }) {
    _id = id;
    _registrationNumber = registrationNumber;
    _make = make;
    _model = model;
    _customerId = customerId;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _registrationNumber = json['registrationNumber'];
    _make = json['make'];
    _model = json['model'];
    _customerId = json['customerId'];
  }
  String? _id;
  String? _registrationNumber;
  String? _make;
  String? _model;
  String? _customerId;
  Result copyWith({
    String? id,
    String? registrationNumber,
    String? make,
    String? model,
    String? customerId,
  }) => Result(
    id: id ?? _id,
    registrationNumber: registrationNumber ?? _registrationNumber,
    make: make ?? _make,
    model: model ?? _model,
    customerId: customerId ?? _customerId,
  );
  String? get id => _id;
  String? get registrationNumber => _registrationNumber;
  String? get make => _make;
  String? get model => _model;
  String? get customerId => _customerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['registrationNumber'] = _registrationNumber;
    map['make'] = _make;
    map['model'] = _model;
    map['customerId'] = _customerId;
    return map;
  }
}
