import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Job card created successfully"
/// result : {"jobCard":{"id":"2677d37a-f8b0-4df3-b700-327c7b43cfe2","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","vehicleId":"6395fe3c-a10b-4022-8349-117bc5515a66","totalCost":7820,"status":"pending","notes":"","serviceDate":"2025-11-10"},"invoice":{"id":"8f1644c8-5527-4899-94eb-d3382c10544e","invoiceNumber":"INV-124374-EZOX4T","totalAmount":7820,"status":"partially-paid","issuedDate":"2025-11-25T05:22:04.553Z","dueDate":"2025-12-02T05:22:04.553Z"},"summary":{"totalCost":7820,"totalPaid":5000,"balanceAmount":2820,"status":"partially-paid","paymentsCount":1}}

class PostJobCardModel {
  PostJobCardModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  PostJobCardModel.fromJson(dynamic json) {
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
  PostJobCardModel copyWith({bool? success, String? message, Result? result}) =>
      PostJobCardModel(
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

/// jobCard : {"id":"2677d37a-f8b0-4df3-b700-327c7b43cfe2","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","vehicleId":"6395fe3c-a10b-4022-8349-117bc5515a66","totalCost":7820,"status":"pending","notes":"","serviceDate":"2025-11-10"}
/// invoice : {"id":"8f1644c8-5527-4899-94eb-d3382c10544e","invoiceNumber":"INV-124374-EZOX4T","totalAmount":7820,"status":"partially-paid","issuedDate":"2025-11-25T05:22:04.553Z","dueDate":"2025-12-02T05:22:04.553Z"}
/// summary : {"totalCost":7820,"totalPaid":5000,"balanceAmount":2820,"status":"partially-paid","paymentsCount":1}

class Result {
  Result({JobCard? jobCard, Invoice? invoice, Summary? summary}) {
    _jobCard = jobCard;
    _invoice = invoice;
    _summary = summary;
  }

  Result.fromJson(dynamic json) {
    _jobCard = json['jobCard'] != null
        ? JobCard.fromJson(json['jobCard'])
        : null;
    _invoice = json['invoice'] != null
        ? Invoice.fromJson(json['invoice'])
        : null;
    _summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
  }
  JobCard? _jobCard;
  Invoice? _invoice;
  Summary? _summary;
  Result copyWith({JobCard? jobCard, Invoice? invoice, Summary? summary}) =>
      Result(
        jobCard: jobCard ?? _jobCard,
        invoice: invoice ?? _invoice,
        summary: summary ?? _summary,
      );
  JobCard? get jobCard => _jobCard;
  Invoice? get invoice => _invoice;
  Summary? get summary => _summary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_jobCard != null) {
      map['jobCard'] = _jobCard?.toJson();
    }
    if (_invoice != null) {
      map['invoice'] = _invoice?.toJson();
    }
    if (_summary != null) {
      map['summary'] = _summary?.toJson();
    }
    return map;
  }
}

/// totalCost : 7820
/// totalPaid : 5000
/// balanceAmount : 2820
/// status : "partially-paid"
/// paymentsCount : 1

class Summary {
  Summary({
    num? totalCost,
    num? totalPaid,
    num? balanceAmount,
    String? status,
    num? paymentsCount,
  }) {
    _totalCost = totalCost;
    _totalPaid = totalPaid;
    _balanceAmount = balanceAmount;
    _status = status;
    _paymentsCount = paymentsCount;
  }

  Summary.fromJson(dynamic json) {
    _totalCost = json['totalCost'];
    _totalPaid = json['totalPaid'];
    _balanceAmount = json['balanceAmount'];
    _status = json['status'];
    _paymentsCount = json['paymentsCount'];
  }
  num? _totalCost;
  num? _totalPaid;
  num? _balanceAmount;
  String? _status;
  num? _paymentsCount;
  Summary copyWith({
    num? totalCost,
    num? totalPaid,
    num? balanceAmount,
    String? status,
    num? paymentsCount,
  }) => Summary(
    totalCost: totalCost ?? _totalCost,
    totalPaid: totalPaid ?? _totalPaid,
    balanceAmount: balanceAmount ?? _balanceAmount,
    status: status ?? _status,
    paymentsCount: paymentsCount ?? _paymentsCount,
  );
  num? get totalCost => _totalCost;
  num? get totalPaid => _totalPaid;
  num? get balanceAmount => _balanceAmount;
  String? get status => _status;
  num? get paymentsCount => _paymentsCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalCost'] = _totalCost;
    map['totalPaid'] = _totalPaid;
    map['balanceAmount'] = _balanceAmount;
    map['status'] = _status;
    map['paymentsCount'] = _paymentsCount;
    return map;
  }
}

/// id : "8f1644c8-5527-4899-94eb-d3382c10544e"
/// invoiceNumber : "INV-124374-EZOX4T"
/// totalAmount : 7820
/// status : "partially-paid"
/// issuedDate : "2025-11-25T05:22:04.553Z"
/// dueDate : "2025-12-02T05:22:04.553Z"

class Invoice {
  Invoice({
    String? id,
    String? invoiceNumber,
    num? totalAmount,
    String? status,
    String? issuedDate,
    String? dueDate,
  }) {
    _id = id;
    _invoiceNumber = invoiceNumber;
    _totalAmount = totalAmount;
    _status = status;
    _issuedDate = issuedDate;
    _dueDate = dueDate;
  }

  Invoice.fromJson(dynamic json) {
    _id = json['id'];
    _invoiceNumber = json['invoiceNumber'];
    _totalAmount = json['totalAmount'];
    _status = json['status'];
    _issuedDate = json['issuedDate'];
    _dueDate = json['dueDate'];
  }
  String? _id;
  String? _invoiceNumber;
  num? _totalAmount;
  String? _status;
  String? _issuedDate;
  String? _dueDate;
  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    num? totalAmount,
    String? status,
    String? issuedDate,
    String? dueDate,
  }) => Invoice(
    id: id ?? _id,
    invoiceNumber: invoiceNumber ?? _invoiceNumber,
    totalAmount: totalAmount ?? _totalAmount,
    status: status ?? _status,
    issuedDate: issuedDate ?? _issuedDate,
    dueDate: dueDate ?? _dueDate,
  );
  String? get id => _id;
  String? get invoiceNumber => _invoiceNumber;
  num? get totalAmount => _totalAmount;
  String? get status => _status;
  String? get issuedDate => _issuedDate;
  String? get dueDate => _dueDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['invoiceNumber'] = _invoiceNumber;
    map['totalAmount'] = _totalAmount;
    map['status'] = _status;
    map['issuedDate'] = _issuedDate;
    map['dueDate'] = _dueDate;
    return map;
  }
}

/// id : "2677d37a-f8b0-4df3-b700-327c7b43cfe2"
/// customerId : "cec28d95-0c91-4c0b-abde-f338c62c220d"
/// vehicleId : "6395fe3c-a10b-4022-8349-117bc5515a66"
/// totalCost : 7820
/// status : "pending"
/// notes : ""
/// serviceDate : "2025-11-10"

class JobCard {
  JobCard({
    String? id,
    String? customerId,
    String? vehicleId,
    num? totalCost,
    String? status,
    String? notes,
    String? serviceDate,
  }) {
    _id = id;
    _customerId = customerId;
    _vehicleId = vehicleId;
    _totalCost = totalCost;
    _status = status;
    _notes = notes;
    _serviceDate = serviceDate;
  }

  JobCard.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _vehicleId = json['vehicleId'];
    _totalCost = json['totalCost'];
    _status = json['status'];
    _notes = json['notes'];
    _serviceDate = json['serviceDate'];
  }
  String? _id;
  String? _customerId;
  String? _vehicleId;
  num? _totalCost;
  String? _status;
  String? _notes;
  String? _serviceDate;
  JobCard copyWith({
    String? id,
    String? customerId,
    String? vehicleId,
    num? totalCost,
    String? status,
    String? notes,
    String? serviceDate,
  }) => JobCard(
    id: id ?? _id,
    customerId: customerId ?? _customerId,
    vehicleId: vehicleId ?? _vehicleId,
    totalCost: totalCost ?? _totalCost,
    status: status ?? _status,
    notes: notes ?? _notes,
    serviceDate: serviceDate ?? _serviceDate,
  );
  String? get id => _id;
  String? get customerId => _customerId;
  String? get vehicleId => _vehicleId;
  num? get totalCost => _totalCost;
  String? get status => _status;
  String? get notes => _notes;
  String? get serviceDate => _serviceDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['vehicleId'] = _vehicleId;
    map['totalCost'] = _totalCost;
    map['status'] = _status;
    map['notes'] = _notes;
    map['serviceDate'] = _serviceDate;
    return map;
  }
}
