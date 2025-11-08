import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Login Successfull"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjgzNmFhNDBjLTFhNTktNGUyNS05YzE1LTdlZGI1ZWNiNTIxNyIsImVtYWlsIjoiYWRtaW5AZ21haWwuY29tIiwic2hvcElkIjoiMDc4MzlmYWEtZGE1ZS00YzVlLTg4MGMtZWJkYTcyMzkwNmMzIiwicm9sZUNvZGUiOiJBRE1JTiIsImlhdCI6MTc2MjU4NTIxNCwiZXhwIjoxNzYzMTkwMDE0fQ.9RnQFSnQfDtlC2Vyi-K8bPujjikT3v9Yoa1zKfj_gR0"
/// refreshToken : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjgzNmFhNDBjLTFhNTktNGUyNS05YzE1LTdlZGI1ZWNiNTIxNyIsImVtYWlsIjoiYWRtaW5AZ21haWwuY29tIiwiaWF0IjoxNzYyNTg1MjE0LCJleHAiOjE3NjMxOTAwMTR9.yyNtiW5xQ_Y5nMsxpYA3eLioKfSVyMKzTYnpUujJCC8"
/// user : {"id":"836aa40c-1a59-4e25-9c15-7edb5ecb5217","firstName":"Rolex","lastName":"S","roleCode":"ADMIN","email":"admin@gmail.com","isActive":true,"shopId":"07839faa-da5e-4c5e-880c-ebda723906c3"}

class PostLoginModel {
  PostLoginModel({
    bool? success,
    String? message,
    String? token,
    String? refreshToken,
    User? user,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _token = token;
    _refreshToken = refreshToken;
    _user = user;
  }

  PostLoginModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _token = json['token'];
    _refreshToken = json['refreshToken'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  String? _message;
  String? _token;
  String? _refreshToken;
  User? _user;
  ErrorResponse? errorResponse;
  PostLoginModel copyWith({
    bool? success,
    String? message,
    String? token,
    String? refreshToken,
    User? user,
  }) => PostLoginModel(
    success: success ?? _success,
    message: message ?? _message,
    token: token ?? _token,
    refreshToken: refreshToken ?? _refreshToken,
    user: user ?? _user,
  );
  bool? get success => _success;
  String? get message => _message;
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['token'] = _token;
    map['refreshToken'] = _refreshToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// id : "836aa40c-1a59-4e25-9c15-7edb5ecb5217"
/// firstName : "Rolex"
/// lastName : "S"
/// roleCode : "ADMIN"
/// email : "admin@gmail.com"
/// isActive : true
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"

class User {
  User({
    String? id,
    String? firstName,
    String? lastName,
    String? roleCode,
    String? email,
    bool? isActive,
    String? shopId,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _roleCode = roleCode;
    _email = email;
    _isActive = isActive;
    _shopId = shopId;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _roleCode = json['roleCode'];
    _email = json['email'];
    _isActive = json['isActive'];
    _shopId = json['shopId'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _roleCode;
  String? _email;
  bool? _isActive;
  String? _shopId;
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? roleCode,
    String? email,
    bool? isActive,
    String? shopId,
  }) => User(
    id: id ?? _id,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    roleCode: roleCode ?? _roleCode,
    email: email ?? _email,
    isActive: isActive ?? _isActive,
    shopId: shopId ?? _shopId,
  );
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get roleCode => _roleCode;
  String? get email => _email;
  bool? get isActive => _isActive;
  String? get shopId => _shopId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['roleCode'] = _roleCode;
    map['email'] = _email;
    map['isActive'] = _isActive;
    map['shopId'] = _shopId;
    return map;
  }
}
