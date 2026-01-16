import 'package:ecomly/models/product_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class VendorProductsProvider extends StateNotifier<List<ProductModel>> {
  VendorProductsProvider() : super([]);

  void setVendorProducts(List<ProductModel> vendorProducts) {
    state = vendorProducts;
  }
}

final vendorProductsProvider = StateNotifierProvider<VendorProductsProvider, List<ProductModel>>(
  (ref) => VendorProductsProvider(),
);
