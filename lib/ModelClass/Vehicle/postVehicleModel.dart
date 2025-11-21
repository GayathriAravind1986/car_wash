import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Vehicle created successfully"
/// result : {"customerId":"57ca83ed-81ee-433f-a3a1-ab0d45cf0f36","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","make":"Chevrolet","model":"Tavera","year":"2025","registrationNumber":"TN69AA1136","vin":null,"color":"White","isActive":true,"isDeleted":false,"id":"23944388-dced-4eba-9dbd-786554c6667b","createdAt":"2025-11-21T05:59:08.291Z","updatedAt":"2025-11-21T05:59:08.291Z"}

class PostVehicleModel {
  PostVehicleModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  PostVehicleModel.fromJson(dynamic json) {
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
  PostVehicleModel copyWith({bool? success, String? message, Result? result}) =>
      PostVehicleModel(
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

/// customerId : "57ca83ed-81ee-433f-a3a1-ab0d45cf0f36"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// make : "Chevrolet"
/// model : "Tavera"
/// year : "2025"
/// registrationNumber : "TN69AA1136"
/// vin : null
/// color : "White"
/// isActive : true
/// isDeleted : false
/// id : "23944388-dced-4eba-9dbd-786554c6667b"
/// createdAt : "2025-11-21T05:59:08.291Z"
/// updatedAt : "2025-11-21T05:59:08.291Z"

class Result {
  Result({
    String? customerId,
    String? shopId,
    String? make,
    String? model,
    String? year,
    String? registrationNumber,
    dynamic vin,
    String? color,
    bool? isActive,
    bool? isDeleted,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    _customerId = customerId;
    _shopId = shopId;
    _make = make;
    _model = model;
    _year = year;
    _registrationNumber = registrationNumber;
    _vin = vin;
    _color = color;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Result.fromJson(dynamic json) {
    _customerId = json['customerId'];
    _shopId = json['shopId'];
    _make = json['make'];
    _model = json['model'];
    _year = json['year'];
    _registrationNumber = json['registrationNumber'];
    _vin = json['vin'];
    _color = json['color'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _id = json['id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _customerId;
  String? _shopId;
  String? _make;
  String? _model;
  String? _year;
  String? _registrationNumber;
  dynamic _vin;
  String? _color;
  bool? _isActive;
  bool? _isDeleted;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  Result copyWith({
    String? customerId,
    String? shopId,
    String? make,
    String? model,
    String? year,
    String? registrationNumber,
    dynamic vin,
    String? color,
    bool? isActive,
    bool? isDeleted,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) => Result(
    customerId: customerId ?? _customerId,
    shopId: shopId ?? _shopId,
    make: make ?? _make,
    model: model ?? _model,
    year: year ?? _year,
    registrationNumber: registrationNumber ?? _registrationNumber,
    vin: vin ?? _vin,
    color: color ?? _color,
    isActive: isActive ?? _isActive,
    isDeleted: isDeleted ?? _isDeleted,
    id: id ?? _id,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  String? get customerId => _customerId;
  String? get shopId => _shopId;
  String? get make => _make;
  String? get model => _model;
  String? get year => _year;
  String? get registrationNumber => _registrationNumber;
  dynamic get vin => _vin;
  String? get color => _color;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customerId'] = _customerId;
    map['shopId'] = _shopId;
    map['make'] = _make;
    map['model'] = _model;
    map['year'] = _year;
    map['registrationNumber'] = _registrationNumber;
    map['vin'] = _vin;
    map['color'] = _color;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['id'] = _id;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
