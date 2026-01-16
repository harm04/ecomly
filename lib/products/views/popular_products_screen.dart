import 'package:ecomly/models/product_model.dart';
import 'package:ecomly/products/widgets/product_card.dart';
import 'package:flutter/material.dart';

class PopularProductScreen extends StatefulWidget {
  final List<ProductModel> popularProducts;
  const PopularProductScreen({super.key, required this.popularProducts});

  @override
  State<PopularProductScreen> createState() => _PopularProductScreenState();
}

class _PopularProductScreenState extends State<PopularProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Products')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 159 / 281,
            crossAxisSpacing: 10,
          ),
          itemCount: widget.popularProducts.length,
          itemBuilder: (context, index) {
            final popularProduct = widget.popularProducts[index];
            return ProductCard(product: popularProduct);
          },
        ),
      ),
    );
  }
}
