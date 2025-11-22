import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Services fecth successfully...!"
/// result : [{"id":"744bd56f-a127-4f70-abb6-4173d74f6220","name":"Water wash","price":500},{"id":"47dafc36-9bb6-4dc0-9464-8b4fbaa5e8fe","name":"Wheel  Alignment","price":2000}]

class GetAllServiceModel {
  GetAllServiceModel({
    bool? success,
    String? message,
    List<Result>? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetAllServiceModel.fromJson(dynamic json) {
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
  GetAllServiceModel copyWith({
    bool? success,
    String? message,
    List<Result>? result,
  }) => GetAllServiceModel(
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

/// id : "744bd56f-a127-4f70-abb6-4173d74f6220"
/// name : "Water wash"
/// price : 500

class Result {
  Result({String? id, String? name, num? price}) {
    _id = id;
    _name = name;
    _price = price;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
  }
  String? _id;
  String? _name;
  num? _price;
  Result copyWith({String? id, String? name, num? price}) =>
      Result(id: id ?? _id, name: name ?? _name, price: price ?? _price);
  String? get id => _id;
  String? get name => _name;
  num? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    return map;
  }
}
