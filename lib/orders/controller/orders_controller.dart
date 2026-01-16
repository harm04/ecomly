import 'dart:convert';

import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/models/orders_model.dart';
import 'package:ecomly/models/product_review_model.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class OrdersController {
  createOrder({
    required String id,
    required String buyerFullName,
    required String buyerEmail,
    required String productName,
    required int quantity,
    required double productPrice,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required String buyerState,
    required String buyerCity,
    required String buyerLocality,
    required String buyerPhone,
    required String buyerPostalCode,
    required String productDescription,
    required bool processing,
    required bool delivered,
    required bool cancelled,
    required context,
    required String productId,
  }) async {
    try {
      final OrdersModel ordersModel = OrdersModel(
        id: id,
        buyerFullName: buyerFullName,
        buyerEmail: buyerEmail,
        productName: productName,
        quantity: quantity,
        productPrice: productPrice,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        buyerState: buyerState,
        buyerCity: buyerCity,
        buyerLocality: buyerLocality,
        buyerPhone: buyerPhone,
        buyerPostalCode: buyerPostalCode,
        processing: processing,
        productDescription: productDescription,
        delivered: delivered,
        cancelled: cancelled,
        productId: productId,

      );
      http.Response response = await http.post(
        Uri.parse('${uri}/api/orders'),
        body: ordersModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Order placed successfully');
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  Future<List<OrdersModel>> fetchUserOrders(String userId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/orders/buyer/$userId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<OrdersModel> orders = data
            .map((order) => OrdersModel.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      throw Exception('Failed to load orders: $error');
    }
  }

  Future<List<OrdersModel>> fetchVendorOrders(String vendorId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/orders/vendor/$vendorId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<OrdersModel> orders = data
            .map((order) => OrdersModel.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      throw Exception('Failed to load orders: $error');
    }
  }

  Future<void> markOrderAsDelivered(String orderId, context) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$orderId/delivered'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'delivered': true, 'processing': false}),
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Order marked as delivered');
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  Future<void> cancellOrder(String orderId, context) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$orderId/cancelled'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'cancelled': true}),
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Order cancelled');
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  Future<void> productReview({
    required String buyerId,
    required String email,
    required String fullName,
    required double rating,
    required String productId,
    required String review,
    required context,
  }) async {
    try {
      final ProductReviewModel productReviewModel = ProductReviewModel(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        rating: rating,
        productId: productId,
        review: review,
      );
      http.Response response = await http.post(
        Uri.parse('${uri}/api/product-review'),
        body: productReviewModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Thanks for rating');
        },
      );
    } catch (error) {
      print('Error in productReview: $error');
      showsnackbar(context, error.toString());
    }
  }

    Future<List<OrdersModel>> fetchOrders() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<OrdersModel> orders = data
            .map((order) => OrdersModel.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      throw Exception('Failed to load orders: $error');
    }
  }
}
