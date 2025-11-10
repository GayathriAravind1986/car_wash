import 'package:carwash/Api/apiProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CustomerEvent {}

class CustomerList extends CustomerEvent {
  String searchKey;
  String offset;
  CustomerList(this.searchKey, this.offset);
}

class CustomerById extends CustomerEvent {
  String cusId;

  CustomerById(this.cusId);
}

// class AddToBilling extends FoodCategoryEvent {
//   List<Map<String, dynamic>> billingItems;
//   bool? isDiscount;
//   final OrderType? orderType;
//   AddToBilling(this.billingItems, this.isDiscount, this.orderType);
// }
//
// class GenerateOrder extends FoodCategoryEvent {
//   final String orderPayloadJson;
//   GenerateOrder(this.orderPayloadJson);
// }
//
// class UpdateOrder extends FoodCategoryEvent {
//   final String orderPayloadJson;
//   String? orderId;
//   UpdateOrder(this.orderPayloadJson, this.orderId);
// }
//
// class TableDine extends FoodCategoryEvent {}
//
// class WaiterDine extends FoodCategoryEvent {}
//
// class StockDetails extends FoodCategoryEvent {}

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
    //   on<AddToBilling>((event, emit) async {
    //     await ApiProvider()
    //         .postAddToBillingAPI(
    //       event.billingItems,
    //       event.isDiscount,
    //       event.orderType?.apiValue,
    //     )
    //         .then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
    //   on<GenerateOrder>((event, emit) async {
    //     await ApiProvider()
    //         .postGenerateOrderAPI(event.orderPayloadJson)
    //         .then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
    //   on<UpdateOrder>((event, emit) async {
    //     await ApiProvider()
    //         .updateGenerateOrderAPI(event.orderPayloadJson, event.orderId)
    //         .then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
    //   on<TableDine>((event, emit) async {
    //     await ApiProvider().getTableAPI().then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
    //   on<WaiterDine>((event, emit) async {
    //     await ApiProvider().getWaiterAPI().then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
    //   on<StockDetails>((event, emit) async {
    //     await ApiProvider().getStockDetailsAPI().then((value) {
    //       emit(value);
    //     }).catchError((error) {
    //       emit(error);
    //     });
    //   });
  }
}
