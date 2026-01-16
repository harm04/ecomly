import 'dart:convert';

class VendorModel {
  final String id;
  final String vendorFullName;
  final String vendorUserId;
  final String vendorEmail;
  final String city;
  final String state;
  final String locality;
  final String postalCode;
  final String phone;
  final String shopName;

  VendorModel({
    required this.id,
    required this.vendorFullName,
    required this.vendorUserId,
    required this.vendorEmail,
    required this.city,
    required this.state,
    required this.locality,
    required this.postalCode,
    required this.phone,
    required this.shopName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vendorFullName': vendorFullName,
      'vendorUserId': vendorUserId,
      'vendorEmail': vendorEmail,
      'city': city,
      'state': state,
      'locality': locality,
      'postalCode': postalCode,
      'phone': phone,
      'shopName': shopName,
    };
  }

  String toJson() => json.encode(toMap());
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map['_id'] as String? ?? '',
      vendorFullName: map['vendorFullName'] as String? ?? '',
      vendorUserId: map['vendorUserId'] as String? ?? '',
      vendorEmail: map['vendorEmail'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      locality: map['locality'] as String? ?? '',
      postalCode: map['postalCode'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      shopName: map['shopName'] as String? ?? '',
    );
  }

  factory VendorModel.fromJson(String source) =>
      VendorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
