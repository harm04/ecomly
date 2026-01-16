import 'dart:convert';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String city;
  final String state;
  final String locality;
  final String postalCode;
  final String phone;
  final String token;
  final bool isAdmin;
  final bool isVendor;


  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.city,
    required this.state,
    required this.locality,
    required this.postalCode,
    required this.phone,
    required this.token,
   required this.isAdmin ,
   required this.isVendor,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'city': city,
      'state': state,
      'locality': locality,
      'postalCode': postalCode,
      'phone': phone,
      'token': token,
      'isAdmin': isAdmin,
      'isVendor': isVendor,
    };
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      locality: map['locality'] as String? ?? '',
      postalCode: map['postalCode'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      token: map['token'] as String? ?? '',
      isAdmin: map['isAdmin'] as bool? ?? false,
      isVendor: map['isVendor'] as bool? ?? false,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
