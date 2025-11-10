import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ShopDetailsEvent {}

class ShopDetailsList extends ShopDetailsEvent {
}

class ShopDetailsBloc extends Bloc<ShopDetailsEvent, dynamic> {
  ShopDetailsBloc() : super(dynamic) {
    on<ShopDetailsList>((event, emit) async {
      await ApiProvider()
          .getShopDetailsAPI()
          .then((value) {
        emit(value);
      })
          .catchError((error) {
        emit(error);
      });
    });
  }
}
