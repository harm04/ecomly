import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/orders_model.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/providers/vendor_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOrderDetailsScreen extends ConsumerStatefulWidget {
  final OrdersModel orderModel;
  const VendorOrderDetailsScreen({super.key, required this.orderModel});

  @override
  ConsumerState<VendorOrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<VendorOrderDetailsScreen> {
  bool isLoading = false;
  void markOrderAsDelivered(String orderId) async {
    setState(() {
      isLoading = true;
    });
    await orderController.markOrderAsDelivered(orderId, context);
    ref
        .read(vendorOrdersProvider.notifier)
        .updateOrderStatus(orderId, delivered: true, processing: false);
    setState(() {
      isLoading = false;
    });
  }

  final OrdersController orderController = OrdersController();
  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(vendorOrdersProvider);
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
      body: SingleChildScrollView(
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
                          style: TextStyle(fontSize: 18, color: Colors.grey),
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
              child: updatedOrder.cancelled == true
                  ? Center(
                      child: Text(
                        'Order cancelled by customer',
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
                        updatedOrder.delivered == true
                            ? Text(
                                'Order delivered',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  markOrderAsDelivered(updatedOrder.id);
                                },
                                child: Text(
                                  'Mark order as delivered',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ],
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
              child: Text(
                'Delivery details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
