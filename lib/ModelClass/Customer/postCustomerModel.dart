import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Customer created successfully"
/// result : {"firstName":"Varun","lastName":"Sundar","phone":"9788034670","email":"varun@gmail.com","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","address":"20-10,Karur,chennai","isActive":true,"isDeleted":false,"id":"5c8a58b3-7c51-412a-b59a-3230397dbb71","createdAt":"2025-11-11T06:28:17.100Z","updatedAt":"2025-11-11T06:28:17.100Z"}

class PostCustomerModel {
  PostCustomerModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  PostCustomerModel.fromJson(dynamic json) {
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
  PostCustomerModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => PostCustomerModel(
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

/// firstName : "Varun"
/// lastName : "Sundar"
/// phone : "9788034670"
/// email : "varun@gmail.com"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// address : "20-10,Karur,chennai"
/// isActive : true
/// isDeleted : false
/// id : "5c8a58b3-7c51-412a-b59a-3230397dbb71"
/// createdAt : "2025-11-11T06:28:17.100Z"
/// updatedAt : "2025-11-11T06:28:17.100Z"

class Result {
  Result({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? shopId,
    String? address,
    bool? isActive,
    bool? isDeleted,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _email = email;
    _shopId = shopId;
    _address = address;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Result.fromJson(dynamic json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _phone = json['phone'];
    _email = json['email'];
    _shopId = json['shopId'];
    _address = json['address'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _id = json['id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _email;
  String? _shopId;
  String? _address;
  bool? _isActive;
  bool? _isDeleted;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  Result copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? shopId,
    String? address,
    bool? isActive,
    bool? isDeleted,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) => Result(
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    phone: phone ?? _phone,
    email: email ?? _email,
    shopId: shopId ?? _shopId,
    address: address ?? _address,
    isActive: isActive ?? _isActive,
    isDeleted: isDeleted ?? _isDeleted,
    id: id ?? _id,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get email => _email;
  String? get shopId => _shopId;
  String? get address => _address;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['phone'] = _phone;
    map['email'] = _email;
    map['shopId'] = _shopId;
    map['address'] = _address;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['id'] = _id;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
