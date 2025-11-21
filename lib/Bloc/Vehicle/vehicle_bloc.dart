import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VehicleEvent {}

class VehicleList extends VehicleEvent {
  String searchKey;
  String offset;
  VehicleList(this.searchKey, this.offset);
}

class VehicleById extends VehicleEvent {
  String vehId;
  VehicleById(this.vehId);
}

class UpdateVehicle extends VehicleEvent {
  String vehId;
  String make;
  String model;
  String year;
  String regNo;
  String color;
  bool active;
  String cusId;
  String shopId;
  UpdateVehicle(
    this.vehId,
    this.make,
    this.model,
    this.year,
    this.regNo,
    this.color,
    this.active,
    this.cusId,
    this.shopId,
  );
}

class CustomerDrop extends VehicleEvent {}

class CreateVehicle extends VehicleEvent {
  String make;
  String model;
  String year;
  String regNo;
  String color;
  bool active;
  String cusId;
  CreateVehicle(
    this.make,
    this.model,
    this.year,
    this.regNo,
    this.color,
    this.active,
    this.cusId,
  );
}

class VehicleBloc extends Bloc<VehicleEvent, dynamic> {
  VehicleBloc() : super(dynamic) {
    on<VehicleList>((event, emit) async {
      await ApiProvider()
          .getAllVehicleAPI(event.searchKey, event.offset)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<VehicleById>((event, emit) async {
      await ApiProvider()
          .getOneVehicleAPI(event.vehId)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<UpdateVehicle>((event, emit) async {
      await ApiProvider()
          .updateVehicleAPI(
            event.vehId,
            event.make,
            event.model,
            event.year,
            event.regNo,
            event.color,
            event.active,
            event.cusId,
            event.shopId,
          )
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CustomerDrop>((event, emit) async {
      await ApiProvider()
          .getCustomerDropAPI()
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CreateVehicle>((event, emit) async {
      await ApiProvider()
          .postVehicleAPI(
            event.make,
            event.model,
            event.year,
            event.regNo,
            event.color,
            event.active,
            event.cusId,
          )
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
  }
}
