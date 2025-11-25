import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class JobCardEvent {}

class JobCardList extends JobCardEvent {
  String searchKey;
  String offset;
  JobCardList(this.searchKey, this.offset);
}

class CustomerDrop extends JobCardEvent {}

class CustomerVehicle extends JobCardEvent {
  String cusId;
  CustomerVehicle(this.cusId);
}

class LocationDrop extends JobCardEvent {}

class ServiceList extends JobCardEvent {}

class SpareList extends JobCardEvent {
  String locId;
  SpareList(this.locId);
}

class CreateJobCard extends JobCardEvent {
  final String summaryPayloadJson;
  CreateJobCard(this.summaryPayloadJson);
}

class JobCardBloc extends Bloc<JobCardEvent, dynamic> {
  JobCardBloc() : super(dynamic) {
    on<JobCardList>((event, emit) async {
      await ApiProvider()
          .getAllJobCardAPI(event.searchKey, event.offset)
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
    on<LocationDrop>((event, emit) async {
      await ApiProvider()
          .getLocationAPI()
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<ServiceList>((event, emit) async {
      await ApiProvider()
          .getAllServiceAPI()
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<SpareList>((event, emit) async {
      await ApiProvider()
          .getAllSpareAPI(event.locId)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<CreateJobCard>((event, emit) async {
      await ApiProvider()
          .postJobCardAPI(event.summaryPayloadJson)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
  }
}
