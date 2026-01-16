import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/category_model.dart';
import 'package:ecomly/models/product_model.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/products/widgets/product_card.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<ProductModel>> futureProductsByCategory;
  @override
  void initState() {
    super.initState();
    futureProductsByCategory = ProductController().fetchProductsByCategory(
      widget.category.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BannerImage(
                    imageUrl: widget.category.banner,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder(
                future: futureProductsByCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 50),
                        Image.asset(Constants.search),
                        SizedBox(height: 20),
                        Text(
                          textAlign: TextAlign.center,
                          'Sorry, we couldn\'t find any matching result for your Search.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    final products = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 159 / 281,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        //product card
                        return ProductCard(product: product);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
