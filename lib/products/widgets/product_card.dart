import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/product_model.dart';
import 'package:ecomly/products/views/product_details_screen.dart';
import 'package:ecomly/providers/favourites_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesProviderData = ref.read(favouritesProvider.notifier);
    ref.watch(favouritesProvider);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductDetailScreen(productModel: product);
                  },
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ProductImage(
                        imageUrl: product.images[0],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '₹${product.productPrice.toString()}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Pallete.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                !favouritesProviderData.getFavouritesItems.containsKey(
                      product.id,
                    )
                    ? favouritesProviderData.addToFavourites(
                        productName: product.productName,
                        category: product.category,
                        productPrice: product.productPrice,
                        images: product.images,
                        vendorId: product.vendorId,
                        productId: product.id,
                        description: product.description,
                        vendorFullName: product.vendorFullName,
                      )
                    : favouritesProviderData.removeFavouritesProduct(
                        product.id,
                      );
                favouritesProviderData.getFavouritesItems.containsKey(
                      product.id,
                    )
                    ? showsnackbar(
                        context,
                        '${product.productName} added to favourites',
                      )
                    : showsnackbar(
                        context,
                        '${product.productName} removed from favourites',
                      );
              },
              child:
                  favouritesProviderData.getFavouritesItems.containsKey(
                    product.id,
                  )
                  ? Image.asset(Constants.heart_filled, height: 30)
                  : Image.asset(Constants.heart, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
