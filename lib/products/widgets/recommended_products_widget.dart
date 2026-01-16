import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/products/views/product_details_screen.dart';
import 'package:ecomly/providers/recommended_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendedProductsWidget extends ConsumerStatefulWidget {
  const RecommendedProductsWidget({super.key});

  @override
  ConsumerState<RecommendedProductsWidget> createState() =>
      _RecommendedProductsWidgetState();
}

class _RecommendedProductsWidgetState
    extends ConsumerState<RecommendedProductsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRecommendedProducts();
    });
  }

  Future<void> fetchRecommendedProducts() async {
    final ProductController productController = ProductController();
    try {
      final recommendedProducts = await productController
          .fetchRecommendedProducts();
      ref
          .read(recommendedProductsProvider.notifier)
          .setRecommendedProducts(recommendedProducts);
    } catch (error) {
      print('Error fetching popular products:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendedProducts = ref.watch(recommendedProductsProvider);
    return recommendedProducts.isEmpty || recommendedProducts.length == 0
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: recommendedProducts.length < 5
                        ? recommendedProducts.length
                        : 5,
                    itemBuilder: (context, index) {
                      final recomendedProduct = recommendedProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailScreen(
                                  productModel: recomendedProduct,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ProductImage(
                              imageUrl: recomendedProduct.images[0],
                              width: 150,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
  }
}
