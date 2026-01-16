import 'package:ecomly/models/cart_model.dart';
import 'package:flutter_riverpod/legacy.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
      (ref) => CartNotifier(),
    );

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});
  //add product to cart
  void addToCart({
    required String productName,
    required String category,
    required double productPrice,
    required List<String> images,
    required String vendorId,
    required int quantity,
    required int orderedQuantity,
    required String productId,
    required String description,
    required String vendorFullName,
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          category: state[productId]!.category,
          productPrice: state[productId]!.productPrice,
          images: state[productId]!.images,
          vendorId: state[productId]!.vendorId,
          quantity: state[productId]!.quantity,
          orderedQuantity: state[productId]!.orderedQuantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          vendorFullName: state[productId]!.vendorFullName,
        ),
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          category: category,
          productPrice: productPrice,
          images: images,
          vendorId: vendorId,
          quantity: quantity,
          orderedQuantity: orderedQuantity,
          productId: productId,
          description: description,
          vendorFullName: vendorFullName,
        ),
      };
    }
  }

  void incrementCartProduct(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.orderedQuantity++;
      state = {...state};
    }
  }

  void decrementCartProduct(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.orderedQuantity--;
      state = {...state};
    }
  }

  removeCartProduct(String productId) {
    if (state.containsKey(productId)) {
      state.remove(productId);
      state = {...state};
    }
  }

  // Add this method to clear all cart items
  void clearCart() {
    state = {};
  }

  double cartTotal() {
    double total = 0.0;
    state.forEach((productId, cartItem) {
      total += cartItem.orderedQuantity * cartItem.productPrice;
    });
    return total;
  }

  Map<String, CartModel> get getCartItems => state;
}
