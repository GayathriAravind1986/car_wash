import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Locations fetched successfully!"
/// result : [{"id":"8fa3c3b6-7455-4a9e-8405-651e4857eb83","locationName":"Tirunelveli","isDefault":true,"addressLine1":"ngo new colony","city":"Tirunelveli","state":"Tamil nadu"}]

class GetLocationModel {
  GetLocationModel({
    bool? success,
    String? message,
    List<Result>? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetLocationModel.fromJson(dynamic json) {
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
  GetLocationModel copyWith({
    bool? success,
    String? message,
    List<Result>? result,
  }) => GetLocationModel(
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

/// id : "8fa3c3b6-7455-4a9e-8405-651e4857eb83"
/// locationName : "Tirunelveli"
/// isDefault : true
/// addressLine1 : "ngo new colony"
/// city : "Tirunelveli"
/// state : "Tamil nadu"

class Result {
  Result({
    String? id,
    String? locationName,
    bool? isDefault,
    String? addressLine1,
    String? city,
    String? state,
  }) {
    _id = id;
    _locationName = locationName;
    _isDefault = isDefault;
    _addressLine1 = addressLine1;
    _city = city;
    _state = state;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _locationName = json['locationName'];
    _isDefault = json['isDefault'];
    _addressLine1 = json['addressLine1'];
    _city = json['city'];
    _state = json['state'];
  }
  String? _id;
  String? _locationName;
  bool? _isDefault;
  String? _addressLine1;
  String? _city;
  String? _state;
  Result copyWith({
    String? id,
    String? locationName,
    bool? isDefault,
    String? addressLine1,
    String? city,
    String? state,
  }) => Result(
    id: id ?? _id,
    locationName: locationName ?? _locationName,
    isDefault: isDefault ?? _isDefault,
    addressLine1: addressLine1 ?? _addressLine1,
    city: city ?? _city,
    state: state ?? _state,
  );
  String? get id => _id;
  String? get locationName => _locationName;
  bool? get isDefault => _isDefault;
  String? get addressLine1 => _addressLine1;
  String? get city => _city;
  String? get state => _state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['locationName'] = _locationName;
    map['isDefault'] = _isDefault;
    map['addressLine1'] = _addressLine1;
    map['city'] = _city;
    map['state'] = _state;
    return map;
  }
}
