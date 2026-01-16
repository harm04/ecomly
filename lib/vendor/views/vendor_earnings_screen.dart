import 'package:ecomly/auth/controller/auth_controller.dart';
import 'package:ecomly/home/widgets/search_card.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/providers/vendor_earnings_provider.dart';
import 'package:ecomly/providers/vendor_order_provider.dart';
import 'package:ecomly/providers/vendor_product_provider.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorEarningsScreen extends ConsumerStatefulWidget {
  const VendorEarningsScreen({super.key});

  @override
  ConsumerState<VendorEarningsScreen> createState() =>
      _VendorEarningsScreenState();
}

class _VendorEarningsScreenState extends ConsumerState<VendorEarningsScreen> {
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchEarnings();
    await fetchVendorProducts();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVendorProducts() async {
    final ProductController productController = ProductController();
    final vendor = ref.read(vendorProvider);
    if (vendor == null) return;

    try {
      print('Fetching products for vendor: ${vendor.id}'); // Debug log
      final vendorProducts = await productController.fetchVendorProducts(
        vendor.id,
      );
      print('Fetched ${vendorProducts.length} products'); // Debug log
      ref
          .read(vendorProductsProvider.notifier)
          .setVendorProducts(vendorProducts);
    } catch (error) {
      print('Error fetching vendor products: $error');
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load products: $error';
        });
      }
    }
  }

  Future<void> fetchEarnings() async {
    final vendor = ref.read(vendorProvider);
    if (vendor != null) {
      OrdersController ordersController = OrdersController();
      try {
        final orders = await ordersController.fetchVendorOrders(vendor.id);
        ref.read(vendorOrdersProvider.notifier).setOrders(orders);
        ref
            .read(vendorEarningsProvider.notifier)
            .calculateTotalEarnings(orders);
      } catch (error) {
        print('Error fetching earnings: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final vendorProducts = ref.watch(vendorProductsProvider);
    final totalEarnings = ref.watch(vendorEarningsProvider);

    if (vendor == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome, ${vendor.vendorFullName}!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AuthController().signOutUser(
                        context: context,
                        ref: ref,
                      );
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Orders Delivered: ${totalEarnings['ordersCount']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '₹${totalEarnings['totalEarnings'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Your Products (${vendorProducts.length})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Expanded(child: _buildProductsList(vendorProducts)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(List vendorProducts) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(errorMessage!, textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  errorMessage = null;
                  isLoading = true;
                });
                _initializeData();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (vendorProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Start by adding some products to your store',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeData,
      child: ListView.builder(
        itemCount: vendorProducts.length,
        itemBuilder: (context, index) {
          final product = vendorProducts[index];
          return GestureDetector(
            onTap: () {},
            child: SearchCard(productModel: product),
          );
        },
      ),
    );
  }
}
