import 'package:ecomly/common/constants.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/orders/widgets/orders_card.dart';
import 'package:ecomly/providers/vendor_order_provider.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:ecomly/vendor/views/vendor_orders_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOrderScreen extends ConsumerStatefulWidget {
  const VendorOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VendorOrderScreenState();
}

class _VendorOrderScreenState extends ConsumerState<VendorOrderScreen> {
  Future<void> fetchVendorOrders() async {
    final vendor =  ref.read(vendorProvider);

    if (vendor != null) {
      final OrdersController ordersController = OrdersController();
      try {
        final orders = await ordersController.fetchVendorOrders(
          vendor.id,
        );
        ref.read(vendorOrdersProvider.notifier).setOrders(orders);
      } catch (error) {
        print('error fetching orders: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVendorOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(vendorOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Constants.empty_orders),
                  SizedBox(height: 20),
                  Text(
                    'No orders yet.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VendorOrderDetailsScreen(orderModel: order);
                        },
                      ),
                    );
                  },
                  child: OrdersCard(orderModel: order),
                );
              },
            ),
    );
  }
}
