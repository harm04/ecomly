import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/products/views/popular_products_screen.dart';
import 'package:ecomly/products/views/product_details_screen.dart';
import 'package:ecomly/providers/popular_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() =>
      _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPopularProducts();
    });
  }

  Future<void> fetchPopularProducts() async {
    final ProductController productController = ProductController();
    try {
      final popularProducts = await productController.fetchPopularProducts();
      ref
          .read(popularProductsProvider.notifier)
          .setPopularProducts(popularProducts);
    } catch (error) {
      print('Error fetching popular products:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularProducts = ref.watch(popularProductsProvider);
    return popularProducts.isEmpty || popularProducts.length == 0
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Container(
              height: 590,
              decoration: BoxDecoration(
                color: Pallete.secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 18,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PopularProductScreen(
                                    popularProducts: popularProducts,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 27,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Image.asset(
                                Constants.right_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Container(
                      height: 510,
                      decoration: BoxDecoration(
                        color: Pallete.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 10,
                              ),
                          itemCount: 4, // Exactly 4 items
                          itemBuilder: (context, index) {
                            final product = popularProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailScreen(
                                        productModel: product,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [],
                                    ),
                                    SizedBox(
                                      height: 170,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        child: ProductImage(
                                          imageUrl:
                                              popularProducts[index].images[0],
                                          width: double.infinity,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      product.productName,
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '₹${product.productPrice.toString()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
