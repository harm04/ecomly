import 'dart:convert';

class FavouritesModel {
  final String productName;
  final String category;
  final double productPrice;
  final List<String> images;
  final String vendorId;
  final String productId;
  final String description;
  final String vendorFullName;

  FavouritesModel({
    required this.productName,
    required this.category,
    required this.productPrice,
    required this.images,
    required this.vendorId,
    required this.productId,
    required this.description,
    required this.vendorFullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'images': images,
      'vendorId': vendorId,
      'productId': productId,
      'description': description,
      'vendorFullName': vendorFullName,
    };
  }

  String toJson() => json.encode(toMap());
  factory FavouritesModel.fromJson(Map<String, dynamic> map) {
    return FavouritesModel(
      productName: map['productName'] as String? ?? '',
      productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,

      category: map['category'] as String? ?? '',
      images: List<String>.from((map['images'] ?? []).map((x) => x as String)),
      productId: map['productId'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      vendorFullName: map['vendorFullName'] as String? ?? '',
    );
  }
}
