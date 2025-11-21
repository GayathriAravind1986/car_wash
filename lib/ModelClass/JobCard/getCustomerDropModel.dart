import 'package:carwash/Bloc/Response/errorResponse.dart';

/// message : "Customers fetched successfully"
/// success : true
/// result : [{"id":"738ffb5e-29d0-437a-a325-9465cfeb4de4","firstName":"gg","lastName":"ghh","email":"sf@gh.c","phone":"5235266","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"e1816fd6-94fe-4b86-9523-58f83f731535","firstName":"vishnu","lastName":"Karuna","email":"karthik234@gmail.com","phone":"8759632514","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"83b2f86a-5b9a-4694-9b5f-3baca39b6939","firstName":"Karthik ","lastName":"kiran","email":"karthik@gmail.com","phone":"7856982135","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"d009374d-f356-44ba-a249-9c8e95381dee","firstName":"sundar","lastName":"das","email":"sundar12@gmail.com","phone":"9856321478","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"f4e713a6-ee90-4e1e-b817-5a536975fd0a","firstName":"Varun","lastName":"Sundar","email":"varun34@gmail.com","phone":"97880346889","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"b0c077ae-e5a6-41b8-b09a-3c789c86ea9d","firstName":"guna","lastName":"jeo","email":"guna34@gmaill.com","phone":"8574523698","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"581d43a0-fa22-456d-bd23-bc64e5664194","firstName":"bino","lastName":"chad","email":"bino23@gmail.com","phone":"8569321458","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"5c8a58b3-7c51-412a-b59a-3230397dbb71","firstName":"Varun","lastName":"Sundar","email":"varun@gmail.com","phone":"9788034670","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"8a5548ef-7dd5-43c3-9eb7-42c709dd76d4","firstName":"Mathan","lastName":"Tech","email":"","phone":"9876543210","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"596a8f2a-d668-49bb-8d21-0c06efbadc9f","firstName":"Sen","lastName":"Tech","email":"","phone":"9876543212","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"ab2ce8f7-0eb3-43f2-9969-5fe4b33b2009","firstName":"Prakash","lastName":"Prakash","email":"","phone":"8122507695","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"cec28d95-0c91-4c0b-abde-f338c62c220d","firstName":"Saranya","lastName":"Thangaraj","email":"sentinix@gmail.com","phone":"801228811","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true},{"id":"f5cb5b43-0c90-48b7-915e-237aba84c1d4","firstName":"Pradeep","lastName":"M","email":"pradeep@yopmail.com","phone":"90289292891","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","isActive":true}]

class GetCustomerDropModel {
  GetCustomerDropModel({
    String? message,
    bool? success,
    List<Result>? result,
    ErrorResponse? errorResponse,
  }) {
    _message = message;
    _success = success;
    _result = result;
  }

  GetCustomerDropModel.fromJson(dynamic json) {
    _message = json['message'];
    _success = json['success'];
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
  String? _message;
  bool? _success;
  List<Result>? _result;
  ErrorResponse? errorResponse;
  GetCustomerDropModel copyWith({
    String? message,
    bool? success,
    List<Result>? result,
  }) => GetCustomerDropModel(
    message: message ?? _message,
    success: success ?? _success,
    result: result ?? _result,
  );
  String? get message => _message;
  bool? get success => _success;
  List<Result>? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['success'] = _success;
    if (_result != null) {
      map['result'] = _result?.map((v) => v.toJson()).toList();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// id : "738ffb5e-29d0-437a-a325-9465cfeb4de4"
/// firstName : "gg"
/// lastName : "ghh"
/// email : "sf@gh.c"
/// phone : "5235266"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// isActive : true

class Result {
  Result({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? shopId,
    bool? isActive,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _shopId = shopId;
    _isActive = isActive;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _phone = json['phone'];
    _shopId = json['shopId'];
    _isActive = json['isActive'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _shopId;
  bool? _isActive;
  Result copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? shopId,
    bool? isActive,
  }) => Result(
    id: id ?? _id,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    email: email ?? _email,
    phone: phone ?? _phone,
    shopId: shopId ?? _shopId,
    isActive: isActive ?? _isActive,
  );
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get shopId => _shopId;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['phone'] = _phone;
    map['shopId'] = _shopId;
    map['isActive'] = _isActive;
    return map;
  }
}
