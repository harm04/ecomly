import 'package:ecomly/models/orders_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class VendorEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  VendorEarningsProvider() : super({'totalEarnings': 0.0, 'ordersCount': 0});

  void calculateTotalEarnings(List<OrdersModel> orders) {
    double earnings = 0.0;
    int ordersCount = 0;
    for (OrdersModel order in orders) {
      if (order.delivered) {
        ordersCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    state = {'totalEarnings': earnings, 'ordersCount': ordersCount};
  }
}

final vendorEarningsProvider =
    StateNotifierProvider<VendorEarningsProvider, Map<String, dynamic>>(
      (ref) => VendorEarningsProvider(),
    );
