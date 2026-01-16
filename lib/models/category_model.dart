import 'dart:convert';

class CategoryModel {
  final String id;
  final String image;
  final String banner;
  final String name;

  CategoryModel({
    required this.id,
    required this.image,
    required this.banner,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'image': image, 'banner': banner, 'name': name};
  }

  String toJson() => json.encode(toMap());
  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['_id'] as String? ?? '',
      image: map['image'] as String? ?? '',
      banner: map['banner'] as String? ?? '',
      name: map['name'] as String? ?? '',
    );
  }


}
