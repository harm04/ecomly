import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/nav_bar.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/orders_model.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/providers/order_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final OrdersModel orderModel;
  const OrderDetailsScreen({super.key, required this.orderModel});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  bool isLoading = false;
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  void cancellOrder(String orderId, context) async {
    setState(() {
      isLoading = true;
    });

    await OrdersController().cancellOrder(orderId, context).whenComplete(() {
      ref
          .read(ordersProvider.notifier)
          .updateOrderStatus(orderId, cancelled: true);
    });
    setState(() {
      isLoading = false;
    });
  }

  //rate order
  void rateOrder(
    String buyerId,
    String email,
    String fullName,
    double rating,
    String review,
    String productId,
    context,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      final OrdersController ordersController = OrdersController();
      print('buyerId: ' + buyerId);
      await ordersController.productReview(
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        rating: rating,
        productId: productId,
        review: review,
        context: context,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showsnackbar(context, 'Error rating the product');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final updatedOrder = orders.firstWhere(
      (o) => o.id == widget.orderModel.id,
      orElse: () => widget.orderModel,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 5,
                ),
                child: Text('Help', style: TextStyle(fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ThumbnailImage(
                              imageUrl: widget.orderModel.image,
                              size: 90,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.orderModel.productName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                widget.orderModel.productDescription,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Order #OD${widget.orderModel.id}',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Pallete.greyColor.withOpacity(0.1),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: updatedOrder.cancelled
                        ? Center(
                            child: Text(
                              'Order cancelled',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                updatedOrder.delivered
                                    ? 'Your order is delivered'
                                    : 'Your order is on the way',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 1,
                                height: 25,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  cancellOrder(updatedOrder.id, context);
                                },
                                child: Text(
                                  'Cancel order',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  updatedOrder.delivered
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              height: 10,
                              width: double.infinity,
                              color: Pallete.greyColor.withOpacity(0.1),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
                              child: Text(
                                'Rate your experience',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBar(
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    onRatingChanged: (value) {
                                      setState(() {
                                        rating = value;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (reviewController.text.isNotEmpty ||
                                          rating > 0) {
                                        rateOrder(
                                          widget.orderModel.buyerId,
                                          widget.orderModel.buyerEmail,
                                          widget.orderModel.buyerFullName,
                                          rating,
                                          reviewController.text.isEmpty
                                              ? 'No review'
                                              : reviewController.text,
                                          widget.orderModel.productId,
                                          context,
                                        );
                                        reviewController.clear();
                                        setState(() {
                                          rating = 0.0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color:
                                            reviewController.text.isNotEmpty ||
                                                rating > 0
                                            ? Pallete.primaryColor
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                reviewController
                                                        .text
                                                        .isNotEmpty ||
                                                    rating > 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
                              child: TextField(
                                controller: reviewController,
                                maxLines: 4,
                                onChanged: (value) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Write a review...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Pallete.greyColor.withOpacity(0.1),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Delivery details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Constants.home,
                                  height: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${widget.orderModel.buyerLocality}, ${widget.orderModel.buyerCity}, ${widget.orderModel.buyerState}, India',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(),
                            ),

                            Row(
                              children: [
                                Image.asset(Constants.profile, height: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.orderModel.buyerFullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        widget.orderModel.buyerPhone,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NavBar();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5,
                          ),
                          child: Center(
                            child: Text(
                              'Shop more on Ecomly',
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color.fromARGB(255, 15, 12, 236),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
