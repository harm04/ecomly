import 'package:ecomly/models/product_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class RecommendedProductsProvider extends StateNotifier<List<ProductModel>> {
  RecommendedProductsProvider() : super([]);

  void setRecommendedProducts(List<ProductModel> recommendedProducts) {
    state = recommendedProducts;
  }
}

final recommendedProductsProvider =
    StateNotifierProvider<RecommendedProductsProvider, List<ProductModel>>(
      (ref) => RecommendedProductsProvider(),
    );
