import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Shop details fetched successfully!"
/// result : {"id":"07839faa-da5e-4c5e-880c-ebda723906c3","shopName":"Rolex car workshop","logo":"https://res.cloudinary.com/dm6wrm7vf/image/upload/v1761759828/shops/lgwr6gtj16jhdmcvdumo.png","isActive":true,"currencySymbol":"₹","taxRate":2}

class GetShopDetailsModel {
  GetShopDetailsModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetShopDetailsModel.fromJson(dynamic json) {
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
  GetShopDetailsModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => GetShopDetailsModel(
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

/// id : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// shopName : "Rolex car workshop"
/// logo : "https://res.cloudinary.com/dm6wrm7vf/image/upload/v1761759828/shops/lgwr6gtj16jhdmcvdumo.png"
/// isActive : true
/// currencySymbol : "₹"
/// taxRate : 2

class Result {
  Result({
    String? id,
    String? shopName,
    String? logo,
    bool? isActive,
    String? currencySymbol,
    num? taxRate,
  }) {
    _id = id;
    _shopName = shopName;
    _logo = logo;
    _isActive = isActive;
    _currencySymbol = currencySymbol;
    _taxRate = taxRate;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _shopName = json['shopName'];
    _logo = json['logo'];
    _isActive = json['isActive'];
    _currencySymbol = json['currencySymbol'];
    _taxRate = json['taxRate'];
  }
  String? _id;
  String? _shopName;
  String? _logo;
  bool? _isActive;
  String? _currencySymbol;
  num? _taxRate;
  Result copyWith({
    String? id,
    String? shopName,
    String? logo,
    bool? isActive,
    String? currencySymbol,
    num? taxRate,
  }) => Result(
    id: id ?? _id,
    shopName: shopName ?? _shopName,
    logo: logo ?? _logo,
    isActive: isActive ?? _isActive,
    currencySymbol: currencySymbol ?? _currencySymbol,
    taxRate: taxRate ?? _taxRate,
  );
  String? get id => _id;
  String? get shopName => _shopName;
  String? get logo => _logo;
  bool? get isActive => _isActive;
  String? get currencySymbol => _currencySymbol;
  num? get taxRate => _taxRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['shopName'] = _shopName;
    map['logo'] = _logo;
    map['isActive'] = _isActive;
    map['currencySymbol'] = _currencySymbol;
    map['taxRate'] = _taxRate;
    return map;
  }
}
