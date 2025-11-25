import 'package:carwash/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Job card fetch successfully"
/// result : {"id":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","locationId":"8fa3c3b6-7455-4a9e-8405-651e4857eb83","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","vehicleId":"6395fe3c-a10b-4022-8349-117bc5515a66","totalCost":"7820.00","status":"pending","notes":"","serviceDate":"2025-11-10T00:00:00.000Z","completionDate":null,"createdAt":"2025-11-10T08:52:37.225Z","updatedAt":"2025-11-10T08:52:37.225Z","jobCardServices":[{"id":"3e883d36-1f6d-4fb8-a103-e452315bb426","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","serviceId":"744bd56f-a127-4f70-abb6-4173d74f6220","price":"0.00","createdAt":"2025-11-10T08:52:37.225Z"},{"id":"145cf2ef-159a-44fe-886f-94dadd68fd13","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","serviceId":"47dafc36-9bb6-4dc0-9464-8b4fbaa5e8fe","price":"0.00","createdAt":"2025-11-10T08:52:37.225Z"}],"jobCardSpares":[{"id":"a28c0733-2c7d-4518-82df-e07005a90bec","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"7e84e73a-33ab-41e3-9742-a2abd30fd0ae","unitPrice":"10.00","quantity":2,"createdAt":"2025-11-10T08:52:37.225Z"},{"id":"5d12879b-1c37-49ed-92c0-41692cb3e173","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"2603b2fc-4c1c-462f-bdfa-623b4959dc35","unitPrice":"150.00","quantity":2,"createdAt":"2025-11-10T08:52:37.225Z"},{"id":"88976e3c-5352-4784-bd24-d470eb06fe06","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"f62c718a-0fcf-4045-a84a-b6eb43739197","unitPrice":"5000.00","quantity":1,"createdAt":"2025-11-10T08:52:37.225Z"}],"invoices":[{"id":"c37b6a6f-91a2-4838-bd0f-7690c9e45728","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","invoiceNumber":"INV-758351-7OQOFN","totalAmount":"7820.00","status":"partially-paid","issuedDate":"2025-11-10T08:52:38.351Z","dueDate":"2025-11-17T08:52:38.351Z","notes":"","createdAt":"2025-11-10T08:52:37.225Z","updatedAt":"2025-11-10T08:52:38.444Z","payments":[]}],"payments":[{"id":"c95d89ec-552b-4198-aa3a-0d894da91414","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","amount":"5000.00","paymentMethod":"cash","paymentDate":"2025-11-03T00:00:00.000Z","isRefunded":false,"notes":"Cash","createdAt":"2025-11-10T08:52:37.225Z","updatedAt":"2025-11-10T08:52:37.225Z"}]}

class GetJobCardDetailsModel {
  GetJobCardDetailsModel({
    bool? success,
    String? message,
    Result? result,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _message = message;
    _result = result;
  }

  GetJobCardDetailsModel.fromJson(dynamic json) {
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
  GetJobCardDetailsModel copyWith({
    bool? success,
    String? message,
    Result? result,
  }) => GetJobCardDetailsModel(
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

/// id : "8677468c-b5f5-4ce2-a097-ea63866ffe6a"
/// customerId : "cec28d95-0c91-4c0b-abde-f338c62c220d"
/// locationId : "8fa3c3b6-7455-4a9e-8405-651e4857eb83"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// vehicleId : "6395fe3c-a10b-4022-8349-117bc5515a66"
/// totalCost : "7820.00"
/// status : "pending"
/// notes : ""
/// serviceDate : "2025-11-10T00:00:00.000Z"
/// completionDate : null
/// createdAt : "2025-11-10T08:52:37.225Z"
/// updatedAt : "2025-11-10T08:52:37.225Z"
/// jobCardServices : [{"id":"3e883d36-1f6d-4fb8-a103-e452315bb426","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","serviceId":"744bd56f-a127-4f70-abb6-4173d74f6220","price":"0.00","createdAt":"2025-11-10T08:52:37.225Z"},{"id":"145cf2ef-159a-44fe-886f-94dadd68fd13","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","serviceId":"47dafc36-9bb6-4dc0-9464-8b4fbaa5e8fe","price":"0.00","createdAt":"2025-11-10T08:52:37.225Z"}]
/// jobCardSpares : [{"id":"a28c0733-2c7d-4518-82df-e07005a90bec","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"7e84e73a-33ab-41e3-9742-a2abd30fd0ae","unitPrice":"10.00","quantity":2,"createdAt":"2025-11-10T08:52:37.225Z"},{"id":"5d12879b-1c37-49ed-92c0-41692cb3e173","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"2603b2fc-4c1c-462f-bdfa-623b4959dc35","unitPrice":"150.00","quantity":2,"createdAt":"2025-11-10T08:52:37.225Z"},{"id":"88976e3c-5352-4784-bd24-d470eb06fe06","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","spareId":"f62c718a-0fcf-4045-a84a-b6eb43739197","unitPrice":"5000.00","quantity":1,"createdAt":"2025-11-10T08:52:37.225Z"}]
/// invoices : [{"id":"c37b6a6f-91a2-4838-bd0f-7690c9e45728","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","invoiceNumber":"INV-758351-7OQOFN","totalAmount":"7820.00","status":"partially-paid","issuedDate":"2025-11-10T08:52:38.351Z","dueDate":"2025-11-17T08:52:38.351Z","notes":"","createdAt":"2025-11-10T08:52:37.225Z","updatedAt":"2025-11-10T08:52:38.444Z","payments":[]}]
/// payments : [{"id":"c95d89ec-552b-4198-aa3a-0d894da91414","jobCardId":"8677468c-b5f5-4ce2-a097-ea63866ffe6a","shopId":"07839faa-da5e-4c5e-880c-ebda723906c3","customerId":"cec28d95-0c91-4c0b-abde-f338c62c220d","amount":"5000.00","paymentMethod":"cash","paymentDate":"2025-11-03T00:00:00.000Z","isRefunded":false,"notes":"Cash","createdAt":"2025-11-10T08:52:37.225Z","updatedAt":"2025-11-10T08:52:37.225Z"}]

class Result {
  Result({
    String? id,
    String? customerId,
    String? locationId,
    String? shopId,
    String? vehicleId,
    String? totalCost,
    String? status,
    String? notes,
    String? serviceDate,
    dynamic completionDate,
    String? createdAt,
    String? updatedAt,
    List<JobCardServices>? jobCardServices,
    List<JobCardSpares>? jobCardSpares,
    List<Invoices>? invoices,
    List<Payments>? payments,
  }) {
    _id = id;
    _customerId = customerId;
    _locationId = locationId;
    _shopId = shopId;
    _vehicleId = vehicleId;
    _totalCost = totalCost;
    _status = status;
    _notes = notes;
    _serviceDate = serviceDate;
    _completionDate = completionDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _jobCardServices = jobCardServices;
    _jobCardSpares = jobCardSpares;
    _invoices = invoices;
    _payments = payments;
  }

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _locationId = json['locationId'];
    _shopId = json['shopId'];
    _vehicleId = json['vehicleId'];
    _totalCost = json['totalCost'];
    _status = json['status'];
    _notes = json['notes'];
    _serviceDate = json['serviceDate'];
    _completionDate = json['completionDate'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['jobCardServices'] != null) {
      _jobCardServices = [];
      json['jobCardServices'].forEach((v) {
        _jobCardServices?.add(JobCardServices.fromJson(v));
      });
    }
    if (json['jobCardSpares'] != null) {
      _jobCardSpares = [];
      json['jobCardSpares'].forEach((v) {
        _jobCardSpares?.add(JobCardSpares.fromJson(v));
      });
    }
    if (json['invoices'] != null) {
      _invoices = [];
      json['invoices'].forEach((v) {
        _invoices?.add(Invoices.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }
  }
  String? _id;
  String? _customerId;
  String? _locationId;
  String? _shopId;
  String? _vehicleId;
  String? _totalCost;
  String? _status;
  String? _notes;
  String? _serviceDate;
  dynamic _completionDate;
  String? _createdAt;
  String? _updatedAt;
  List<JobCardServices>? _jobCardServices;
  List<JobCardSpares>? _jobCardSpares;
  List<Invoices>? _invoices;
  List<Payments>? _payments;
  Result copyWith({
    String? id,
    String? customerId,
    String? locationId,
    String? shopId,
    String? vehicleId,
    String? totalCost,
    String? status,
    String? notes,
    String? serviceDate,
    dynamic completionDate,
    String? createdAt,
    String? updatedAt,
    List<JobCardServices>? jobCardServices,
    List<JobCardSpares>? jobCardSpares,
    List<Invoices>? invoices,
    List<Payments>? payments,
  }) => Result(
    id: id ?? _id,
    customerId: customerId ?? _customerId,
    locationId: locationId ?? _locationId,
    shopId: shopId ?? _shopId,
    vehicleId: vehicleId ?? _vehicleId,
    totalCost: totalCost ?? _totalCost,
    status: status ?? _status,
    notes: notes ?? _notes,
    serviceDate: serviceDate ?? _serviceDate,
    completionDate: completionDate ?? _completionDate,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
    jobCardServices: jobCardServices ?? _jobCardServices,
    jobCardSpares: jobCardSpares ?? _jobCardSpares,
    invoices: invoices ?? _invoices,
    payments: payments ?? _payments,
  );
  String? get id => _id;
  String? get customerId => _customerId;
  String? get locationId => _locationId;
  String? get shopId => _shopId;
  String? get vehicleId => _vehicleId;
  String? get totalCost => _totalCost;
  String? get status => _status;
  String? get notes => _notes;
  String? get serviceDate => _serviceDate;
  dynamic get completionDate => _completionDate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<JobCardServices>? get jobCardServices => _jobCardServices;
  List<JobCardSpares>? get jobCardSpares => _jobCardSpares;
  List<Invoices>? get invoices => _invoices;
  List<Payments>? get payments => _payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['locationId'] = _locationId;
    map['shopId'] = _shopId;
    map['vehicleId'] = _vehicleId;
    map['totalCost'] = _totalCost;
    map['status'] = _status;
    map['notes'] = _notes;
    map['serviceDate'] = _serviceDate;
    map['completionDate'] = _completionDate;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_jobCardServices != null) {
      map['jobCardServices'] = _jobCardServices
          ?.map((v) => v.toJson())
          .toList();
    }
    if (_jobCardSpares != null) {
      map['jobCardSpares'] = _jobCardSpares?.map((v) => v.toJson()).toList();
    }
    if (_invoices != null) {
      map['invoices'] = _invoices?.map((v) => v.toJson()).toList();
    }
    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "c95d89ec-552b-4198-aa3a-0d894da91414"
/// jobCardId : "8677468c-b5f5-4ce2-a097-ea63866ffe6a"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// customerId : "cec28d95-0c91-4c0b-abde-f338c62c220d"
/// amount : "5000.00"
/// paymentMethod : "cash"
/// paymentDate : "2025-11-03T00:00:00.000Z"
/// isRefunded : false
/// notes : "Cash"
/// createdAt : "2025-11-10T08:52:37.225Z"
/// updatedAt : "2025-11-10T08:52:37.225Z"

class Payments {
  Payments({
    String? id,
    String? jobCardId,
    String? shopId,
    String? customerId,
    String? amount,
    String? paymentMethod,
    String? paymentDate,
    bool? isRefunded,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _jobCardId = jobCardId;
    _shopId = shopId;
    _customerId = customerId;
    _amount = amount;
    _paymentMethod = paymentMethod;
    _paymentDate = paymentDate;
    _isRefunded = isRefunded;
    _notes = notes;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Payments.fromJson(dynamic json) {
    _id = json['id'];
    _jobCardId = json['jobCardId'];
    _shopId = json['shopId'];
    _customerId = json['customerId'];
    _amount = json['amount'];
    _paymentMethod = json['paymentMethod'];
    _paymentDate = json['paymentDate'];
    _isRefunded = json['isRefunded'];
    _notes = json['notes'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _jobCardId;
  String? _shopId;
  String? _customerId;
  String? _amount;
  String? _paymentMethod;
  String? _paymentDate;
  bool? _isRefunded;
  String? _notes;
  String? _createdAt;
  String? _updatedAt;
  Payments copyWith({
    String? id,
    String? jobCardId,
    String? shopId,
    String? customerId,
    String? amount,
    String? paymentMethod,
    String? paymentDate,
    bool? isRefunded,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) => Payments(
    id: id ?? _id,
    jobCardId: jobCardId ?? _jobCardId,
    shopId: shopId ?? _shopId,
    customerId: customerId ?? _customerId,
    amount: amount ?? _amount,
    paymentMethod: paymentMethod ?? _paymentMethod,
    paymentDate: paymentDate ?? _paymentDate,
    isRefunded: isRefunded ?? _isRefunded,
    notes: notes ?? _notes,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  String? get id => _id;
  String? get jobCardId => _jobCardId;
  String? get shopId => _shopId;
  String? get customerId => _customerId;
  String? get amount => _amount;
  String? get paymentMethod => _paymentMethod;
  String? get paymentDate => _paymentDate;
  bool? get isRefunded => _isRefunded;
  String? get notes => _notes;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['jobCardId'] = _jobCardId;
    map['shopId'] = _shopId;
    map['customerId'] = _customerId;
    map['amount'] = _amount;
    map['paymentMethod'] = _paymentMethod;
    map['paymentDate'] = _paymentDate;
    map['isRefunded'] = _isRefunded;
    map['notes'] = _notes;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

/// id : "c37b6a6f-91a2-4838-bd0f-7690c9e45728"
/// jobCardId : "8677468c-b5f5-4ce2-a097-ea63866ffe6a"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// customerId : "cec28d95-0c91-4c0b-abde-f338c62c220d"
/// invoiceNumber : "INV-758351-7OQOFN"
/// totalAmount : "7820.00"
/// status : "partially-paid"
/// issuedDate : "2025-11-10T08:52:38.351Z"
/// dueDate : "2025-11-17T08:52:38.351Z"
/// notes : ""
/// createdAt : "2025-11-10T08:52:37.225Z"
/// updatedAt : "2025-11-10T08:52:38.444Z"
/// payments : []

class Invoices {
  Invoices({
    String? id,
    String? jobCardId,
    String? shopId,
    String? customerId,
    String? invoiceNumber,
    String? totalAmount,
    String? status,
    String? issuedDate,
    String? dueDate,
    String? notes,
    String? createdAt,
    String? updatedAt,
    List<Payments>? payments,
  }) {
    _id = id;
    _jobCardId = jobCardId;
    _shopId = shopId;
    _customerId = customerId;
    _invoiceNumber = invoiceNumber;
    _totalAmount = totalAmount;
    _status = status;
    _issuedDate = issuedDate;
    _dueDate = dueDate;
    _notes = notes;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _payments = payments;
  }

  Invoices.fromJson(dynamic json) {
    _id = json['id'];
    _jobCardId = json['jobCardId'];
    _shopId = json['shopId'];
    _customerId = json['customerId'];
    _invoiceNumber = json['invoiceNumber'];
    _totalAmount = json['totalAmount'];
    _status = json['status'];
    _issuedDate = json['issuedDate'];
    _dueDate = json['dueDate'];
    _notes = json['notes'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['payments'] != null) {
      _payments = [];
      json['payments'].forEach((v) {
        _payments?.add(Payments.fromJson(v));
      });
    }
  }
  String? _id;
  String? _jobCardId;
  String? _shopId;
  String? _customerId;
  String? _invoiceNumber;
  String? _totalAmount;
  String? _status;
  String? _issuedDate;
  String? _dueDate;
  String? _notes;
  String? _createdAt;
  String? _updatedAt;
  List<Payments>? _payments;
  Invoices copyWith({
    String? id,
    String? jobCardId,
    String? shopId,
    String? customerId,
    String? invoiceNumber,
    String? totalAmount,
    String? status,
    String? issuedDate,
    String? dueDate,
    String? notes,
    String? createdAt,
    String? updatedAt,
    List<Payments>? payments,
  }) => Invoices(
    id: id ?? _id,
    jobCardId: jobCardId ?? _jobCardId,
    shopId: shopId ?? _shopId,
    customerId: customerId ?? _customerId,
    invoiceNumber: invoiceNumber ?? _invoiceNumber,
    totalAmount: totalAmount ?? _totalAmount,
    status: status ?? _status,
    issuedDate: issuedDate ?? _issuedDate,
    dueDate: dueDate ?? _dueDate,
    notes: notes ?? _notes,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
    payments: payments ?? _payments,
  );
  String? get id => _id;
  String? get jobCardId => _jobCardId;
  String? get shopId => _shopId;
  String? get customerId => _customerId;
  String? get invoiceNumber => _invoiceNumber;
  String? get totalAmount => _totalAmount;
  String? get status => _status;
  String? get issuedDate => _issuedDate;
  String? get dueDate => _dueDate;
  String? get notes => _notes;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<Payments>? get payments => _payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['jobCardId'] = _jobCardId;
    map['shopId'] = _shopId;
    map['customerId'] = _customerId;
    map['invoiceNumber'] = _invoiceNumber;
    map['totalAmount'] = _totalAmount;
    map['status'] = _status;
    map['issuedDate'] = _issuedDate;
    map['dueDate'] = _dueDate;
    map['notes'] = _notes;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_payments != null) {
      map['payments'] = _payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "a28c0733-2c7d-4518-82df-e07005a90bec"
/// jobCardId : "8677468c-b5f5-4ce2-a097-ea63866ffe6a"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// spareId : "7e84e73a-33ab-41e3-9742-a2abd30fd0ae"
/// unitPrice : "10.00"
/// quantity : 2
/// createdAt : "2025-11-10T08:52:37.225Z"

class JobCardSpares {
  JobCardSpares({
    String? id,
    String? jobCardId,
    String? shopId,
    String? spareId,
    String? unitPrice,
    num? quantity,
    String? createdAt,
  }) {
    _id = id;
    _jobCardId = jobCardId;
    _shopId = shopId;
    _spareId = spareId;
    _unitPrice = unitPrice;
    _quantity = quantity;
    _createdAt = createdAt;
  }

  JobCardSpares.fromJson(dynamic json) {
    _id = json['id'];
    _jobCardId = json['jobCardId'];
    _shopId = json['shopId'];
    _spareId = json['spareId'];
    _unitPrice = json['unitPrice'];
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _jobCardId;
  String? _shopId;
  String? _spareId;
  String? _unitPrice;
  num? _quantity;
  String? _createdAt;
  JobCardSpares copyWith({
    String? id,
    String? jobCardId,
    String? shopId,
    String? spareId,
    String? unitPrice,
    num? quantity,
    String? createdAt,
  }) => JobCardSpares(
    id: id ?? _id,
    jobCardId: jobCardId ?? _jobCardId,
    shopId: shopId ?? _shopId,
    spareId: spareId ?? _spareId,
    unitPrice: unitPrice ?? _unitPrice,
    quantity: quantity ?? _quantity,
    createdAt: createdAt ?? _createdAt,
  );
  String? get id => _id;
  String? get jobCardId => _jobCardId;
  String? get shopId => _shopId;
  String? get spareId => _spareId;
  String? get unitPrice => _unitPrice;
  num? get quantity => _quantity;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['jobCardId'] = _jobCardId;
    map['shopId'] = _shopId;
    map['spareId'] = _spareId;
    map['unitPrice'] = _unitPrice;
    map['quantity'] = _quantity;
    map['createdAt'] = _createdAt;
    return map;
  }
}

/// id : "3e883d36-1f6d-4fb8-a103-e452315bb426"
/// jobCardId : "8677468c-b5f5-4ce2-a097-ea63866ffe6a"
/// shopId : "07839faa-da5e-4c5e-880c-ebda723906c3"
/// serviceId : "744bd56f-a127-4f70-abb6-4173d74f6220"
/// price : "0.00"
/// createdAt : "2025-11-10T08:52:37.225Z"

class JobCardServices {
  JobCardServices({
    String? id,
    String? jobCardId,
    String? shopId,
    String? serviceId,
    String? price,
    String? createdAt,
  }) {
    _id = id;
    _jobCardId = jobCardId;
    _shopId = shopId;
    _serviceId = serviceId;
    _price = price;
    _createdAt = createdAt;
  }

  JobCardServices.fromJson(dynamic json) {
    _id = json['id'];
    _jobCardId = json['jobCardId'];
    _shopId = json['shopId'];
    _serviceId = json['serviceId'];
    _price = json['price'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _jobCardId;
  String? _shopId;
  String? _serviceId;
  String? _price;
  String? _createdAt;
  JobCardServices copyWith({
    String? id,
    String? jobCardId,
    String? shopId,
    String? serviceId,
    String? price,
    String? createdAt,
  }) => JobCardServices(
    id: id ?? _id,
    jobCardId: jobCardId ?? _jobCardId,
    shopId: shopId ?? _shopId,
    serviceId: serviceId ?? _serviceId,
    price: price ?? _price,
    createdAt: createdAt ?? _createdAt,
  );
  String? get id => _id;
  String? get jobCardId => _jobCardId;
  String? get shopId => _shopId;
  String? get serviceId => _serviceId;
  String? get price => _price;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['jobCardId'] = _jobCardId;
    map['shopId'] = _shopId;
    map['serviceId'] = _serviceId;
    map['price'] = _price;
    map['createdAt'] = _createdAt;
    return map;
  }
}
