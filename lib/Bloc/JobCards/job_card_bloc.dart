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
  }
}
