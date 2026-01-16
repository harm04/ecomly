import 'package:ecomly/cart/views/add_address_screen.dart';
import 'package:ecomly/cart/views/checkout_screen.dart';
import 'package:ecomly/cart/widgets/cart_card.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/providers/cart_provider.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final userData = ref.watch(userProvider);
    final cartTotal = ref.read(cartProvider.notifier).cartTotal();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 124),
        child: SizedBox(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('My Cart', style: TextStyle(fontSize: 24)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Delivery to',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${userData!.fullName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            userData.locality == '' ||
                                    userData.city == '' ||
                                    userData.state == '' ||
                                    userData.postalCode == ''
                                ? Text(
                                    'Add shipping address',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Text(
                                    '${userData.locality}, ${userData.city}, ${userData.state} - ${userData.postalCode}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Pallete.greyColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                            child: Text(
                              userData.locality == '' ||
                                      userData.city == '' ||
                                      userData.state == '' ||
                                      userData.postalCode == ''
                                  ? 'Add address'
                                  : 'Change',
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color.fromARGB(255, 15, 12, 236),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Pallete.greyColor.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Constants.empty_cart),
                    SizedBox(height: 20),
                    Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      print(cartItem.productName);
                      return CartCard(cartModel: cartItem, isCartScreen: true);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Pallete.greyColor.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: const Color.fromARGB(255, 225, 225, 225),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price (${cartData.length} items)',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '₹${cartData.values.fold(0.0, (sum, item) => sum + (item.productPrice * item.orderedQuantity * 0.34 + item.productPrice * item.orderedQuantity)).toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '- ₹${cartData.values.fold(0.0, (sum, item) => sum + (item.productPrice * item.orderedQuantity * 0.34 + item.productPrice * item.orderedQuantity) - item.productPrice * item.orderedQuantity).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Free',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: const Color.fromARGB(255, 225, 225, 225),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹${cartData.values.fold(0.0, (sum, item) => sum + (item.productPrice * item.orderedQuantity)).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 241, 229),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Constants.discount_percent,
                                      height: 25,
                                      color: const Color.fromARGB(
                                        255,
                                        4,
                                        138,
                                        8,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'You\'ll save ₹${cartData.values.fold(0.0, (sum, item) => sum + (item.productPrice * item.orderedQuantity * 0.34)).toStringAsFixed(2)} on this order',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          4,
                                          138,
                                          8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 180),
                ],
              ),
            ),
      bottomSheet: cartData.isEmpty
          ? null
          : Padding(
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
                          '₹$cartTotal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (userData.state != '' &&
                                userData.city != '' &&
                                userData.postalCode != '' &&
                                userData.locality != '') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please complete your address before placing the order.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Checkout',
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
