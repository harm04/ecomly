import 'package:ecomly/common/constants.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/orders/views/order_details_screen.dart';
import 'package:ecomly/orders/widgets/orders_card.dart';
import 'package:ecomly/providers/order_provider.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  Future<void> fetchUserOrders() async {
    final user = ref.read(userProvider);
  
    if (user != null) {
      final OrdersController ordersController = OrdersController();
      try {
        final orders = await ordersController.fetchUserOrders(user.id);
        print('userid: ${user.id}');
        ref.read(ordersProvider.notifier).setOrders(orders);
      } catch (error) {
        print('error fetching orders: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
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
                          return OrderDetailsScreen(orderModel: order);
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
