import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final double productPrice;
  final String description;
  final int quantity;
  final String category;
  final List<String> images;
  final String vendorId;
  final String vendorFullName;
  final double averageRating;
  final int totalRatings;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.description,
    required this.quantity,
    required this.category,
    required this.images,
    required this.averageRating,
    required this.totalRatings,
    required this.vendorId,
    required this.vendorFullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'description': description,
      'quantity': quantity,
      'category': category,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'vendorId': vendorId,
      'vendorFullName': vendorFullName,
    };
  }

  String toJson() => json.encode(toMap());
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      images: List<String>.from((map['images'] ?? []).map((x) => x as String)),
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: map['totalRatings'] as int? ?? 0,
      vendorId: map['vendorId'] as String? ?? '',
      vendorFullName: map['vendorFullName'] as String? ?? '',
    );
  }

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
