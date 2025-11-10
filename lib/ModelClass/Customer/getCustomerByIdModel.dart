import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Customer fetch successfully"
/// result : {"id":"8a5548ef-7dd5-43c3-9eb7-42c709dd76d4","firstName":"Mathan","lastName":"Tech","email":"","phone":"9876543210","isActive":true}

class GetCustomerByIdModel {
  GetCustomerByIdModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetCustomerByIdModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  String? _message;
  Result? _result;
  ErrorResponse? errorResponse;
  GetCustomerByIdModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => GetCustomerByIdModel(
    success: success ?? _success,
    message: message ?? _message,
    result: result ?? _result,
  );
  bool? get success => _success;
  String? get message => _message;
  Result? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// id : "8a5548ef-7dd5-43c3-9eb7-42c709dd76d4"
/// firstName : "Mathan"
/// lastName : "Tech"
/// email : ""
/// phone : "9876543210"
/// isActive : true

class Result {
  Result({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? isActive,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _isActive = isActive;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _phone = json['phone'];
    _isActive = json['isActive'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  bool? _isActive;
  Result copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? isActive,
  }) => Result(
    id: id ?? _id,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    email: email ?? _email,
    phone: phone ?? _phone,
    isActive: isActive ?? _isActive,
  );
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['phone'] = _phone;
    map['isActive'] = _isActive;
    return map;
  }
}
