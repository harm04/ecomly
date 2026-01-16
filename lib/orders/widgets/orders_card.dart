import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/orders_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersCard extends StatelessWidget {
  final OrdersModel orderModel;
  const OrdersCard({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: ThumbnailImage(imageUrl: orderModel.image, size: 100),
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    orderModel.delivered
                        ? Text(
                            'Delivered on 27th Nov',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            'Processing order',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    SizedBox(height: 5),
                    Text(
                      orderModel.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹${orderModel.productPrice.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),

                    Text(
                      orderModel.cancelled
                          ? 'Cancelled'
                          : orderModel.delivered
                          ? 'Delivered'
                          : orderModel.processing
                          ? 'Processing'
                          : 'Pending',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: orderModel.delivered
                            ? Colors.green
                            : orderModel.processing
                            ? Colors.orange
                            : orderModel.cancelled
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
