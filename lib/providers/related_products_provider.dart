import 'package:ecomly/models/product_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class RelatedProductsProvider extends StateNotifier<List<ProductModel>> {
  RelatedProductsProvider() : super([]);

  void setRelatedProducts(List<ProductModel> relatedProducts) {
    state = relatedProducts;
  }
}

final relatedProductsProvider =
    StateNotifierProvider<RelatedProductsProvider, List<ProductModel>>(
      (ref) => RelatedProductsProvider(),
    );
