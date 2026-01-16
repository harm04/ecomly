class CartModel {
  final String productName;
  final String category;
  final double productPrice;
  final List<String> images;
  final String vendorId;
  final int quantity;
   int orderedQuantity;
  final String productId;
  final String description;
  final String vendorFullName;

  CartModel({required this.productName, required this.category, required this.productPrice, required this.images, required this.vendorId, required this.quantity, required this.orderedQuantity, required this.productId, required this.description, required this.vendorFullName});
}
