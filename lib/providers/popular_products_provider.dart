import 'package:ecomly/models/product_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class PopularProductsProvider extends StateNotifier<List<ProductModel>> {
  PopularProductsProvider() : super([]);

  void setPopularProducts(List<ProductModel> popularProducts) {
    state = popularProducts;
  }
}

final popularProductsProvider = StateNotifierProvider<PopularProductsProvider, List<ProductModel>>(
  (ref) => PopularProductsProvider(),
);
