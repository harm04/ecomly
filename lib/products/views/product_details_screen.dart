import 'package:ecomly/cart/views/add_address_screen.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/product_model.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/providers/cart_provider.dart';
import 'package:ecomly/providers/related_products_provider.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel productModel;
  const ProductDetailScreen({super.key, required this.productModel});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRelatedProducts();
    });
  }

  Future<void> fetchRelatedProducts() async {
    final ProductController productController = ProductController();
    try {
      final relatedProducts = await productController.fetchRelatedProducts(
        widget.productModel.id,
      );
      ref
          .read(relatedProductsProvider.notifier)
          .setRelatedProducts(relatedProducts);
    } catch (error) {
      print('Error fetching popular products:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final user = ref.watch(userProvider);
    final relatedProducts = ref.watch(relatedProductsProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 430,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.productModel.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          color: Pallete.secondaryColor,
                          child: ProductImage(
                            imageUrl: widget.productModel.images[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        icon: Image.asset(Constants.back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.productModel.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Pallete.primaryColor
                          : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productModel.productName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 10),
                    Row(
                      children: [
                        //discounted price
                        Text(
                          '₹${((widget.productModel.productPrice * 0.34) + widget.productModel.productPrice).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '₹${widget.productModel.productPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Pallete.primaryColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(Constants.discount, height: 20),
                        SizedBox(width: 4),
                        Text(
                          '24% OFF',
                          style: TextStyle(
                            fontSize: 14,
                            color: Pallete.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.productModel.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    widget.productModel.averageRating == 0
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                'Ratings and reviews',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.productModel.averageRating
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '(${widget.productModel.totalRatings.toString()} ratings)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(height: 20),
                    Text(
                      'Delivery details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 233, 249),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: Pallete.primaryColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddAddressScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                user!.locality == ''
                                    ? 'Please set your delivery address'
                                    : 'Deliver to ${user.locality}, ${user.city}, ${user.state} - ${user.postalCode}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        'Delivery by Tomorrow, 10 AM',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Constants.replacement, height: 40),
                            SizedBox(height: 5),
                            Text(
                              '7 Days\nReplacement',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Constants.cod, height: 40),
                            SizedBox(height: 5),
                            Text(
                              'Cash on\nDelivery',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Constants.delivery, height: 40),
                            SizedBox(height: 5),
                            Text(
                              'Fast\nDelivery',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Related Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: relatedProducts.length < 5
                            ? relatedProducts.length
                            : 5,
                        itemBuilder: (context, index) {
                          final recomendedProduct = relatedProducts[index];
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
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 180),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Pallete.primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${widget.productModel.productPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _cartProvider.addToCart(
                        productName: widget.productModel.productName,
                        category: widget.productModel.category,
                        productPrice: widget.productModel.productPrice,
                        images: widget.productModel.images,
                        vendorId: widget.productModel.vendorId,
                        quantity: widget.productModel.quantity,
                        orderedQuantity: 1,
                        productId: widget.productModel.id,
                        description: widget.productModel.description,
                        vendorFullName: widget.productModel.vendorFullName,
                      );

                      showsnackbar(
                        context,
                        '${widget.productModel.productName} added to cart',
                      );
                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
