import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Customers fetched successfully"
/// result : {"items":[{"id":"8a5548ef-7dd5-43c3-9eb7-42c709dd76d4","firstName":"Mathan","lastName":"Tech","email":"","phone":"9876543210","isActive":true,"address":"Ad"},{"id":"f5cb5b43-0c90-48b7-915e-237aba84c1d4","firstName":"Pradeep","lastName":"M","email":"pradeep@yopmail.com","phone":"90289292891","isActive":true,"address":"Nagapattinam"},{"id":"ab2ce8f7-0eb3-43f2-9969-5fe4b33b2009","firstName":"Prakash","lastName":"Prakash","email":"","phone":"8122507695","isActive":true,"address":"Tirunelveli Municipal Incubation Center\nSripuram"},{"id":"cec28d95-0c91-4c0b-abde-f338c62c220d","firstName":"Saranya","lastName":"Thangaraj","email":"sentinix@gmail.com","phone":"801228811","isActive":true,"address":"VKPuram"},{"id":"596a8f2a-d668-49bb-8d21-0c06efbadc9f","firstName":"Sen","lastName":"Tech","email":"","phone":"9876543212","isActive":true,"address":"Ad"}],"total":5}

class GetAllCustomerModel {
  GetAllCustomerModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetAllCustomerModel.fromJson(dynamic json) {
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
  GetAllCustomerModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => GetAllCustomerModel(
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

/// items : [{"id":"8a5548ef-7dd5-43c3-9eb7-42c709dd76d4","firstName":"Mathan","lastName":"Tech","email":"","phone":"9876543210","isActive":true,"address":"Ad"},{"id":"f5cb5b43-0c90-48b7-915e-237aba84c1d4","firstName":"Pradeep","lastName":"M","email":"pradeep@yopmail.com","phone":"90289292891","isActive":true,"address":"Nagapattinam"},{"id":"ab2ce8f7-0eb3-43f2-9969-5fe4b33b2009","firstName":"Prakash","lastName":"Prakash","email":"","phone":"8122507695","isActive":true,"address":"Tirunelveli Municipal Incubation Center\nSripuram"},{"id":"cec28d95-0c91-4c0b-abde-f338c62c220d","firstName":"Saranya","lastName":"Thangaraj","email":"sentinix@gmail.com","phone":"801228811","isActive":true,"address":"VKPuram"},{"id":"596a8f2a-d668-49bb-8d21-0c06efbadc9f","firstName":"Sen","lastName":"Tech","email":"","phone":"9876543212","isActive":true,"address":"Ad"}]
/// total : 5

class Result {
  Result({List<Items>? items, num? total}) {
    _items = items;
    _total = total;
  }

  Result.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _total = json['total'];
  }
  List<Items>? _items;
  num? _total;
  Result copyWith({List<Items>? items, num? total}) =>
      Result(items: items ?? _items, total: total ?? _total);
  List<Items>? get items => _items;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }
}

/// id : "8a5548ef-7dd5-43c3-9eb7-42c709dd76d4"
/// firstName : "Mathan"
/// lastName : "Tech"
/// email : ""
/// phone : "9876543210"
/// isActive : true
/// address : "Ad"

class Items {
  Items({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? isActive,
    String? address,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _isActive = isActive;
    _address = address;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _phone = json['phone'];
    _isActive = json['isActive'];
    _address = json['address'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  bool? _isActive;
  String? _address;
  Items copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? isActive,
    String? address,
  }) => Items(
    id: id ?? _id,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    email: email ?? _email,
    phone: phone ?? _phone,
    isActive: isActive ?? _isActive,
    address: address ?? _address,
  );
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  bool? get isActive => _isActive;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['phone'] = _phone;
    map['isActive'] = _isActive;
    map['address'] = _address;
    return map;
  }
}
