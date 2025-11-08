import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// result : [{"id":"1e4a7a24-6d79-4068-991f-e13062ece59e","registrationNumber":"Tn76 8986","customerName":"","totalCost":"2500.00","status":"in-progress","invoiceStatus":"paid","createdAt":"2025-11-05T07:23:19.639Z"},{"id":"9acb8703-59cd-4bae-b424-f89f3fd66ca2","registrationNumber":"TN-51-MP-1208","customerName":"","totalCost":"2150.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-11-01T11:13:06.968Z"},{"id":"8e86dfbf-cdd1-41dc-ad30-8e836345f738","registrationNumber":"Tn76 8986","customerName":"","totalCost":"500.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-11-01T06:19:07.784Z"},{"id":"f9729acc-3453-4f31-aac4-8da8c204a7be","registrationNumber":"Tn76 8986","customerName":"","totalCost":"500.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-11-01T06:19:07.766Z"},{"id":"cb1dee1c-26b1-45da-ad7c-548a9b66d545","registrationNumber":"Tn76 8986","customerName":"","totalCost":"500.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-11-01T06:19:07.593Z"},{"id":"c905f031-102d-444c-bca8-d4cede6909be","registrationNumber":"TN76BY8986","customerName":"","totalCost":"7650.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-11-01T05:57:33.682Z"},{"id":"5ccec842-a24a-405c-96e6-0d3d86166429","registrationNumber":"TN76BY8986","customerName":"","totalCost":"2650.00","status":"pending","invoiceStatus":"partially-paid","createdAt":"2025-11-01T05:50:07.473Z"},{"id":"cf64a0a6-93c6-4f5d-bf96-127769458654","registrationNumber":"TN76BY8986","customerName":"","totalCost":"5650.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-10-31T17:47:15.525Z"},{"id":"95475eb7-1ab3-48d5-af39-c890e1958f1d","registrationNumber":"TN-51-MP-1208","customerName":"","totalCost":"150.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-10-31T15:47:38.377Z"},{"id":"1b67e403-fbb7-45a5-8d37-2bffd51daac0","registrationNumber":"TN76BY8986","customerName":"","totalCost":"650.00","status":"pending","invoiceStatus":"pending","createdAt":"2025-10-31T14:59:57.627Z"}]
/// pagination : {"total":15,"limit":10,"offset":0,"hasMore":true}

class GetAllJobCardModel {
  GetAllJobCardModel({
    bool? success,
    List<Result>? result,
    Pagination? pagination,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _result = result;
    _pagination = pagination;
  }

  GetAllJobCardModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result?.add(Result.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  List<Result>? _result;
  Pagination? _pagination;
  ErrorResponse? errorResponse;
  GetAllJobCardModel copyWith({
    bool? success,
    List<Result>? result,
    Pagination? pagination,
  }) => GetAllJobCardModel(
    success: success ?? _success,
    result: result ?? _result,
    pagination: pagination ?? _pagination,
  );
  bool? get success => _success;
  List<Result>? get result => _result;
  Pagination? get pagination => _pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_result != null) {
      map['result'] = _result?.map((v) => v.toJson()).toList();
    }
    if (_pagination != null) {
      map['pagination'] = _pagination?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// total : 15
/// limit : 10
/// offset : 0
/// hasMore : true

class Pagination {
  Pagination({num? total, num? limit, num? offset, bool? hasMore}) {
    _total = total;
    _limit = limit;
    _offset = offset;
    _hasMore = hasMore;
  }

  Pagination.fromJson(dynamic json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    _hasMore = json['hasMore'];
  }
  num? _total;
  num? _limit;
  num? _offset;
  bool? _hasMore;
  Pagination copyWith({num? total, num? limit, num? offset, bool? hasMore}) =>
      Pagination(
        total: total ?? _total,
        limit: limit ?? _limit,
        offset: offset ?? _offset,
        hasMore: hasMore ?? _hasMore,
      );
  num? get total => _total;
  num? get limit => _limit;
  num? get offset => _offset;
  bool? get hasMore => _hasMore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['limit'] = _limit;
    map['offset'] = _offset;
    map['hasMore'] = _hasMore;
    return map;
  }
}

/// id : "1e4a7a24-6d79-4068-991f-e13062ece59e"
/// registrationNumber : "Tn76 8986"
/// customerName : ""
/// totalCost : "2500.00"
/// status : "in-progress"
/// invoiceStatus : "paid"
/// createdAt : "2025-11-05T07:23:19.639Z"

class Result {
  Result({
    String? id,
    String? registrationNumber,
    String? customerName,
    String? totalCost,
    String? status,
    String? invoiceStatus,
    String? createdAt,
  }) {
    _id = id;
    _registrationNumber = registrationNumber;
    _customerName = customerName;
    _totalCost = totalCost;
    _status = status;
    _invoiceStatus = invoiceStatus;
    _createdAt = createdAt;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _registrationNumber = json['registrationNumber'];
    _customerName = json['customerName'];
    _totalCost = json['totalCost'];
    _status = json['status'];
    _invoiceStatus = json['invoiceStatus'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _registrationNumber;
  String? _customerName;
  String? _totalCost;
  String? _status;
  String? _invoiceStatus;
  String? _createdAt;
  Result copyWith({
    String? id,
    String? registrationNumber,
    String? customerName,
    String? totalCost,
    String? status,
    String? invoiceStatus,
    String? createdAt,
  }) => Result(
    id: id ?? _id,
    registrationNumber: registrationNumber ?? _registrationNumber,
    customerName: customerName ?? _customerName,
    totalCost: totalCost ?? _totalCost,
    status: status ?? _status,
    invoiceStatus: invoiceStatus ?? _invoiceStatus,
    createdAt: createdAt ?? _createdAt,
  );
  String? get id => _id;
  String? get registrationNumber => _registrationNumber;
  String? get customerName => _customerName;
  String? get totalCost => _totalCost;
  String? get status => _status;
  String? get invoiceStatus => _invoiceStatus;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['registrationNumber'] = _registrationNumber;
    map['customerName'] = _customerName;
    map['totalCost'] = _totalCost;
    map['status'] = _status;
    map['invoiceStatus'] = _invoiceStatus;
    map['createdAt'] = _createdAt;
    return map;
  }
}
