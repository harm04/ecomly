import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/cart_model.dart';
import 'package:ecomly/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartCard extends ConsumerStatefulWidget {
  final CartModel cartModel;
  final bool isCartScreen;
  const CartCard({
    super.key,
    required this.cartModel,
    required this.isCartScreen,
  });

  @override
  ConsumerState<CartCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ThumbnailImage(
                              imageUrl: widget.cartModel.images[0],
                              size: 80,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        widget.isCartScreen
                            ? Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _cartProvider.decrementCartProduct(
                                            widget.cartModel.productId,
                                          );
                                        },
                                        child: Text(
                                          ' - ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        widget.cartModel.orderedQuantity
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _cartProvider.incrementCartProduct(
                                            widget.cartModel.productId,
                                          );
                                        },
                                        child: Text(
                                          ' + ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cartModel.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.cartModel.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Pallete.greyColor,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              //discounted price
                              Text(
                                '₹${((widget.cartModel.productPrice * 0.34) + widget.cartModel.productPrice).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '₹${widget.cartModel.productPrice.toStringAsFixed(2)}',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Image.asset(Constants.delivery, height: 25),
                    SizedBox(width: 5),
                    Text(
                      'Express',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 24, 191, 232),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Delivery in 2 days, Tue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              widget.isCartScreen
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _cartProvider.removeCartProduct(
                                widget.cartModel.productId,
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(Constants.delete, height: 20),
                                SizedBox(width: 5),
                                Text('Remove', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 20, color: Colors.grey),
                          Row(
                            children: [
                              Image.asset(Constants.heart, height: 15),
                              SizedBox(width: 5),
                              Text(
                                'Save to favourites',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 20, color: Colors.grey),
                          Row(
                            children: [
                              Image.asset(Constants.thunder, height: 20),
                              SizedBox(width: 5),
                              Text(
                                'Buy this now',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),

              widget.isCartScreen ? Divider() : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
