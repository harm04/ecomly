import 'dart:convert';
import 'dart:io';
import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:ecomly/services/cloudinary_optimizer.dart';
import 'package:http/http.dart' as http;

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomly/models/product_model.dart';

class ProductController {
  Future<void> uploadProducts({
    required String productName,
    required String productDescription,
    required double productPrice,
    required int quantity,
    required String category,
    required String vendorId,
    required String vendorFullName,
    required List<File?> images,
    required context,
  }) async {
    try {
      List<String> imageUrls = [];
      for (var i = 0; i < images.length; i++) {
        if (images[i] != null) {
          // Upload product image with optimizations
          CloudinaryResponse res =
              await CloudinaryOptimizer.uploadOptimizedFile(
                file: CloudinaryFile.fromFile(
                  images[i]!.path,
                  folder: productName,
                ),
              );

          String imageUrl = res.secureUrl;
          imageUrls.add(imageUrl);
        }
      }
      ProductModel productModel = ProductModel(
        id: '',
        productName: productName,
        productPrice: productPrice,
        description: productDescription,
        quantity: quantity,
        category: category,
        images: imageUrls,
        vendorId: vendorId,
        vendorFullName: vendorFullName,
        averageRating: 0.0,
        totalRatings: 0,
      );

      http.Response response = await http.post(
        Uri.parse('${uri}/api/add-product'),
        body: productModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Product uploaded successfully');
        },
      );
    } catch (error) {
      print('Error uploading to Cloudinary: $error');
      showsnackbar(context, 'Error uploading product: ${error.toString()}');
    }
  }

  Future<List<ProductModel>> fetchPopularProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${uri}/api/popular-products"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> popularProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return popularProducts;
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/products-by-category/$category'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> categoryProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return categoryProducts;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<ProductModel>> fetchRecommendedProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${uri}/api/recommend-products"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> recommendedProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return recommendedProducts;
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  Future<List<ProductModel>> fetchRelatedProducts(String productId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/related-products/$productId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> relatedProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return relatedProducts;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/search-products?query=$query'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> searchedProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return searchedProducts;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<ProductModel>> fetchVendorProducts(String vendorId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${uri}/api/product/vendor/$vendorId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<ProductModel> vendorProducts = data
            .map(
              (products) =>
                  ProductModel.fromMap(products as Map<String, dynamic>),
            )
            .toList();
        return vendorProducts;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
