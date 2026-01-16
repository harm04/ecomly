import 'dart:convert';

class OrdersModel {
  final String id;
  final String buyerFullName;
  final String buyerEmail;
  final String productName;
  final int quantity;
  final double productPrice;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final String buyerState;
  final String buyerCity;
  final String buyerLocality;
  final String buyerPhone;
  final String buyerPostalCode;
  final bool processing;
  final bool delivered;
  final bool cancelled;
  final String productDescription;
  final String productId;

  OrdersModel({
    required this.id,
    required this.buyerFullName,
    required this.buyerEmail,
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.buyerState,
    required this.buyerCity,
    required this.buyerLocality,
    required this.buyerPhone,
    required this.buyerPostalCode,
    required this.processing,
    required this.delivered,
    required this.cancelled,
    required this.productDescription ,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'buyerFullName': buyerFullName,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'buyerState': buyerState,
      'buyerCity': buyerCity,
      'buyerLocality': buyerLocality,
      'buyerPhone': buyerPhone,
      'buyerPostalCode': buyerPostalCode,
      'processing': processing,
      'delivered': delivered,
      'productDescription': productDescription,
      'vendorId': vendorId,
      'cancelled': cancelled,
      'buyerEmail': buyerEmail,
      'productId': productId,
    };
  }

  String toJson() => json.encode(toMap());
  factory OrdersModel.fromJson(Map<String, dynamic> map) {
    return OrdersModel(
      id: map['_id'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,
      buyerCity: map['buyerCity'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      buyerId: map['buyerId'] as String? ?? '',
      buyerState: map['buyerState'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
      buyerEmail: map['buyerEmail'] as String? ?? '',
      productDescription: map['productDescription'] as String? ?? '',
      buyerFullName: map['buyerFullName'] as String? ?? '',
      buyerLocality: map['buyerLocality'] as String? ?? '',
      buyerPhone: map['buyerPhone'] as String? ?? '',
      buyerPostalCode: map['buyerPostalCode'] as String? ?? '',
      processing: map['processing'] as bool? ?? false,
      delivered: map['delivered'] as bool? ?? false,
      cancelled: map['cancelled'] as bool? ?? false,
      productId: map['productId'] as String? ?? '',
    );
  }
}
