import 'package:ecomly/models/orders_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderProvider extends StateNotifier<List<OrdersModel>> {
  OrderProvider() : super([]);

  void setOrders(List<OrdersModel> ordersModel) {
    state = ordersModel;
  }

  void updateOrderStatus(
    String orderId, {
    bool? processing,
    bool? delivered,
    bool? cancelled,
  }) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          OrdersModel(
            id: order.id,
            buyerFullName: order.buyerFullName,
            buyerEmail: order.buyerEmail,
            productName: order.productName,
            quantity: order.quantity,
            productPrice: order.productPrice,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            buyerState: order.buyerState,
            buyerCity: order.buyerCity,
            buyerLocality: order.buyerLocality,
            buyerPhone: order.buyerPhone,
            buyerPostalCode: order.buyerPostalCode,
            processing: processing ?? order.processing,
            delivered: delivered ?? order.delivered,
            cancelled: cancelled ?? order.cancelled,
            productDescription: order.productDescription,
            productId: order.productId,
          )
        else
          order,
    ];
    print('Updated order status for orderId: $orderId');
  }
}

final ordersProvider = StateNotifierProvider<OrderProvider, List<OrdersModel>>(
  (ref) => OrderProvider(),
);
