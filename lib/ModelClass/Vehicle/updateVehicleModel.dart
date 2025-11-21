import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Vehicle updated successfully"
/// result : {"id":"bb447e68-6bbf-4795-bc7d-6fcb60d4fce2","make":"Swift","model":"Vxi","year":"2025","registrationNumber":"Tn76 8986","vin":"","color":"White","isActive":false,"customerId":"ab2ce8f7-0eb3-43f2-9969-5fe4b33b2009","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3"}

class UpdateVehicleModel {
  UpdateVehicleModel({bool? success, String? message, Result? result, ErrorResponse? errorResponse,}) {
    _success = success;
    _message = message;
    _result = result;
  }

  UpdateVehicleModel.fromJson(dynamic json) {
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
  UpdateVehicleModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => UpdateVehicleModel(
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

/// id : "bb447e68-6bbf-4795-bc7d-6fcb60d4fce2"
/// make : "Swift"
/// model : "Vxi"
/// year : "2025"
/// registrationNumber : "Tn76 8986"
/// vin : ""
/// color : "White"
/// isActive : false
/// customerId : "ab2ce8f7-0eb3-43f2-9969-5fe4b33b2009"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"

class Result {
  Result({
    String? id,
    String? make,
    String? model,
    String? year,
    String? registrationNumber,
    String? vin,
    String? color,
    bool? isActive,
    String? customerId,
    String? shopId,
  }) {
    _id = id;
    _make = make;
    _model = model;
    _year = year;
    _registrationNumber = registrationNumber;
    _vin = vin;
    _color = color;
    _isActive = isActive;
    _customerId = customerId;
    _shopId = shopId;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _make = json['make'];
    _model = json['model'];
    _year = json['year'];
    _registrationNumber = json['registrationNumber'];
    _vin = json['vin'];
    _color = json['color'];
    _isActive = json['isActive'];
    _customerId = json['customerId'];
    _shopId = json['shopId'];
  }
  String? _id;
  String? _make;
  String? _model;
  String? _year;
  String? _registrationNumber;
  String? _vin;
  String? _color;
  bool? _isActive;
  String? _customerId;
  String? _shopId;
  Result copyWith({
    String? id,
    String? make,
    String? model,
    String? year,
    String? registrationNumber,
    String? vin,
    String? color,
    bool? isActive,
    String? customerId,
    String? shopId,
  }) => Result(
    id: id ?? _id,
    make: make ?? _make,
    model: model ?? _model,
    year: year ?? _year,
    registrationNumber: registrationNumber ?? _registrationNumber,
    vin: vin ?? _vin,
    color: color ?? _color,
    isActive: isActive ?? _isActive,
    customerId: customerId ?? _customerId,
    shopId: shopId ?? _shopId,
  );
  String? get id => _id;
  String? get make => _make;
  String? get model => _model;
  String? get year => _year;
  String? get registrationNumber => _registrationNumber;
  String? get vin => _vin;
  String? get color => _color;
  bool? get isActive => _isActive;
  String? get customerId => _customerId;
  String? get shopId => _shopId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['make'] = _make;
    map['model'] = _model;
    map['year'] = _year;
    map['registrationNumber'] = _registrationNumber;
    map['vin'] = _vin;
    map['color'] = _color;
    map['isActive'] = _isActive;
    map['customerId'] = _customerId;
    map['shopId'] = _shopId;
    return map;
  }
}
