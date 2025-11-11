import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CustomerEvent {}

class CustomerList extends CustomerEvent {
  String searchKey;
  String offset;
  CustomerList(this.searchKey, this.offset);
}

class CreateCustomer extends CustomerEvent {
  String firstName;
  String lastName;
  String phone;
  String email;
  String address;
  bool active;
  CreateCustomer(
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.active,
  );
}

class CustomerById extends CustomerEvent {
  String cusId;
  CustomerById(this.cusId);
}

class UpdateCustomer extends CustomerEvent {
  String cusId;
  String firstName;
  String lastName;
  String phone;
  String email;
  String address;
  bool active;
  UpdateCustomer(
    this.cusId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.active,
  );
}

class CustomerVehicle extends CustomerEvent {
  String cusId;
  CustomerVehicle(this.cusId);
}

class CustomerBloc extends Bloc<CustomerEvent, dynamic> {
  CustomerBloc() : super(dynamic) {
    on<CustomerList>((event, emit) async {
      await ApiProvider()
          .getAllCustomerAPI(event.searchKey, event.offset)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CreateCustomer>((event, emit) async {
      await ApiProvider()
          .postCustomerAPI(
            event.firstName,
            event.lastName,
            event.phone,
            event.email,
            event.address,
            event.active,
          )
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CustomerById>((event, emit) async {
      await ApiProvider()
          .getCustomerByIdAPI(event.cusId)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<UpdateCustomer>((event, emit) async {
      await ApiProvider()
          .updateCustomerAPI(
            event.cusId,
            event.firstName,
            event.lastName,
            event.phone,
            event.email,
            event.address,
            event.active,
          )
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CustomerVehicle>((event, emit) async {
      await ApiProvider()
          .getVehicleByCustomerAPI(event.cusId)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
  }
}
