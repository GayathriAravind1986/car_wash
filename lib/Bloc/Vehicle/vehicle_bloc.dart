import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VehicleEvent {}

class VehicleList extends VehicleEvent {
  String searchKey;
  String offset;
  VehicleList(this.searchKey, this.offset);
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
  }
}
