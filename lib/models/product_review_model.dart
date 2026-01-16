import 'dart:convert';

class ProductReviewModel {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final double rating;
  final String productId;
  final String review;

  ProductReviewModel({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.rating,
    required this.productId,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'email': email,
      'fullName': fullName,
      'rating': rating,
      'productId': productId,
      'review': review,
    };
  }

  String toJson() => json.encode(toMap());
  factory ProductReviewModel.fromJson(Map<String, dynamic> map) {
    return ProductReviewModel(
      id: map['_id'] as String? ?? '',
      buyerId: map['buyerId'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      productId: map['productId'] as String? ?? '',
      review: map['review'] as String? ?? '',
    );
  }
}
