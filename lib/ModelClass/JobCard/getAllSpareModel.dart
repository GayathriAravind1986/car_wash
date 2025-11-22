import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Spares fetch successfully"
/// result : [{"id":"7e84e73a-33ab-41e3-9742-a2abd30fd0ae","name":"Bold","partNumber":"123","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true,"isDeleted":false,"createdAt":"2025-11-05T09:44:37.356Z","modifiedAt":"2025-11-05T09:44:37.356Z","inStock":5,"unitPrice":"10.00","locationId":"8fa3c3b6-7455-4a9e-8405-651e4857eb83"},{"id":"2603b2fc-4c1c-462f-bdfa-623b4959dc35","name":"Brake oil","partNumber":"8920OKPL","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true,"isDeleted":false,"createdAt":"2025-10-28T03:12:52.684Z","modifiedAt":"2025-10-28T03:12:52.684Z","inStock":82,"unitPrice":"150.00","locationId":"8fa3c3b6-7455-4a9e-8405-651e4857eb83"},{"id":"e8c21760-cd86-46ed-b621-53e91eac46c9","name":"Clutch pad","partNumber":"029902","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true,"isDeleted":false,"createdAt":"2025-10-28T03:13:12.515Z","modifiedAt":"2025-10-28T03:13:12.515Z","inStock":0,"unitPrice":"100.00","locationId":"8fa3c3b6-7455-4a9e-8405-651e4857eb83"},{"id":"f62c718a-0fcf-4045-a84a-b6eb43739197","name":"Wheel","partNumber":"12","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true,"isDeleted":false,"createdAt":"2025-10-30T05:09:25.917Z","modifiedAt":"2025-10-30T05:09:25.917Z","inStock":500,"unitPrice":"5000.00","locationId":"8fa3c3b6-7455-4a9e-8405-651e4857eb83"}]

class GetAllSpareModel {
  GetAllSpareModel({
    bool? success,
    String? message,
    List<Result>? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetAllSpareModel.fromJson(dynamic json) {
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
  GetAllSpareModel copyWith({
    bool? success,
    String? message,
    List<Result>? result,
  }) => GetAllSpareModel(
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

/// id : "7e84e73a-33ab-41e3-9742-a2abd30fd0ae"
/// name : "Bold"
/// partNumber : "123"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// isActive : true
/// isDeleted : false
/// createdAt : "2025-11-05T09:44:37.356Z"
/// modifiedAt : "2025-11-05T09:44:37.356Z"
/// inStock : 5
/// unitPrice : "10.00"
/// locationId : "8fa3c3b6-7455-4a9e-8405-651e4857eb83"

class Result {
  Result({
    String? id,
    String? name,
    String? partNumber,
    String? shopId,
    bool? isActive,
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? inStock,
    String? unitPrice,
    String? locationId,
  }) {
    _id = id;
    _name = name;
    _partNumber = partNumber;
    _shopId = shopId;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _modifiedAt = modifiedAt;
    _inStock = inStock;
    _unitPrice = unitPrice;
    _locationId = locationId;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _partNumber = json['partNumber'];
    _shopId = json['shopId'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _modifiedAt = json['modifiedAt'];
    _inStock = json['inStock'];
    _unitPrice = json['unitPrice'];
    _locationId = json['locationId'];
  }
  String? _id;
  String? _name;
  String? _partNumber;
  String? _shopId;
  bool? _isActive;
  bool? _isDeleted;
  String? _createdAt;
  String? _modifiedAt;
  num? _inStock;
  String? _unitPrice;
  String? _locationId;
  Result copyWith({
    String? id,
    String? name,
    String? partNumber,
    String? shopId,
    bool? isActive,
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? inStock,
    String? unitPrice,
    String? locationId,
  }) => Result(
    id: id ?? _id,
    name: name ?? _name,
    partNumber: partNumber ?? _partNumber,
    shopId: shopId ?? _shopId,
    isActive: isActive ?? _isActive,
    isDeleted: isDeleted ?? _isDeleted,
    createdAt: createdAt ?? _createdAt,
    modifiedAt: modifiedAt ?? _modifiedAt,
    inStock: inStock ?? _inStock,
    unitPrice: unitPrice ?? _unitPrice,
    locationId: locationId ?? _locationId,
  );
  String? get id => _id;
  String? get name => _name;
  String? get partNumber => _partNumber;
  String? get shopId => _shopId;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get modifiedAt => _modifiedAt;
  num? get inStock => _inStock;
  String? get unitPrice => _unitPrice;
  String? get locationId => _locationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['partNumber'] = _partNumber;
    map['shopId'] = _shopId;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['modifiedAt'] = _modifiedAt;
    map['inStock'] = _inStock;
    map['unitPrice'] = _unitPrice;
    map['locationId'] = _locationId;
    return map;
  }
}
