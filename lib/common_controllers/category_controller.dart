import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomly/models/category_model.dart';
import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:ecomly/services/cloudinary_optimizer.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategoryImage({
    required dynamic categoryImage,
    required dynamic bannerImage,
    required String categoryName,
    required context,
  }) async {
    try {
      // Upload category image with optimizations
      CloudinaryResponse categoryRes =
          await CloudinaryOptimizer.uploadOptimizedFile(
            file: CloudinaryFile.fromBytesData(
              categoryImage,
              identifier: categoryName,
              folder: 'CategoryImages',
            ),
          );
      String categoryImageUrl = categoryRes.secureUrl;

      // Upload banner image with optimizations
      CloudinaryResponse bannerRes =
          await CloudinaryOptimizer.uploadOptimizedFile(
            file: CloudinaryFile.fromBytesData(
              bannerImage,
              identifier: categoryName,
              folder: 'BannerImages',
            ),
          );

      String bannerImageUrl = bannerRes.secureUrl;

      CategoryModel categoryModel = CategoryModel(
        id: '',
        image: categoryImageUrl,
        banner: bannerImageUrl,
        name: categoryName,
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/category'),
        body: categoryModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Catgeory added');
        },
      );
    } catch (error) {
      print('Error uploading to Cloudinary: $error');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<CategoryModel> categories = data
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Failed to load categories: $error');
    }
  }
}
