import 'package:ecomly/models/category_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class CategoryProvider extends StateNotifier<List<CategoryModel>> {
  CategoryProvider() : super([]);
  void setCategories(List<CategoryModel> categories) async {
    state = categories;
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryProvider, List<CategoryModel>>(
      (ref) => CategoryProvider(),
    );
