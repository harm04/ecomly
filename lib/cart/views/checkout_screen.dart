import 'package:ecomly/cart/views/add_address_screen.dart';
import 'package:ecomly/cart/views/order_success_screen.dart';
import 'package:ecomly/cart/widgets/cart_card.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/global_variables.dart' as GlobalVariables;
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:ecomly/providers/cart_provider.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'razorpay';
  late Razorpay _razorpay;
  bool isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse paymentResponse) async {
    print('Payment Success: ${paymentResponse.paymentId}');

    final userData = ref.read(userProvider);
    final cartData = ref.read(cartProvider);

    // Prepare cart items for backend
    final cartItems = cartData.values
        .map(
          (item) => {
            'productId': item.productId,
            'quantity': item.orderedQuantity,
          },
        )
        .toList();

    try {
      // Verify payment with backend
      final httpResponse = await http.post(
        Uri.parse('${GlobalVariables.uri}/api/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_order_id': paymentResponse.orderId,
          'razorpay_payment_id': paymentResponse.paymentId,
          'razorpay_signature': paymentResponse.signature,
          'cartItems': cartItems,
          'userId': userData!.id,
        }),
      );

      if (httpResponse.statusCode == 200) {
        final responseData = jsonDecode(httpResponse.body);
        if (responseData['success']) {
          // Create orders in your system
          await _createOrdersAfterPayment();

          // Clear cart and navigate to success screen
          await _clearCart();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
          );
        } else {
          _showErrorSnackBar('Payment verification failed');
        }
      } else {
        _showErrorSnackBar('Failed to verify payment');
      }
    } catch (e) {
      print('Error verifying payment: $e');
      _showErrorSnackBar('Error verifying payment');
    }

    setState(() {
      isProcessingPayment = false;
    });
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    _showErrorSnackBar('Payment failed: ${response.message}');

    setState(() {
      isProcessingPayment = false;
    });
  }

  // Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  // Clear cart manually since clearCart method doesn't exist
  Future<void> _clearCart() async {
    final cart = ref.read(cartProvider.notifier);
    cart.clearCart();
  }

  // Create orders after successful payment
  Future<void> _createOrdersAfterPayment() async {
    final userData = ref.read(userProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final OrdersController _ordersController = OrdersController();

    await Future.forEach(_cartProvider.getCartItems.entries, (entry) {
      var item = entry.value;
      _ordersController.createOrder(
        id: '',
        buyerFullName: userData!.fullName,
        buyerEmail: userData.email,
        productName: item.productName,
        quantity: item.orderedQuantity,
        productPrice: item.productPrice,
        category: item.category,
        image: item.images[0],
        buyerId: userData.id,
        vendorId: item.vendorId,
        buyerState: userData.state,
        buyerCity: userData.city,
        buyerLocality: userData.locality,
        buyerPhone: userData.phone,
        buyerPostalCode: userData.postalCode,
        processing: true,
        delivered: false,
        cancelled: false,
        context: context,
        productDescription: item.description,
        productId: item.productId,
      );
    });
  }

  // Start Razorpay payment
  Future<void> _startRazorpayPayment() async {
    if (isProcessingPayment) return;

    setState(() {
      isProcessingPayment = true;
    });

    final userData = ref.read(userProvider);
    final cartData = ref.read(cartProvider);

    // Prepare cart items for backend
    final cartItems = cartData.values
        .map(
          (item) => {
            'productId': item.productId,
            'quantity': item.orderedQuantity,
          },
        )
        .toList();

    // Prepare shipping address
    final shippingAddress = {
      'address': userData!.locality,
      'city': userData.city,
      'state': userData.state,
      'postalCode': userData.postalCode,
      'phone': userData.phone,
    };

    try {
      // Create order on backend
      final httpResponse = await http.post(
        Uri.parse('${GlobalVariables.uri}/api/create-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userData.id,
          'cartItems': cartItems,
          'shippingAddress': shippingAddress,
        }),
      );

      if (httpResponse.statusCode == 200) {
        final responseData = jsonDecode(httpResponse.body);

        if (responseData['success']) {
          // Configure Razorpay options
          var options = {
            'key': responseData['key'],
            'amount': responseData['amount'],
            'currency': responseData['currency'],
            'order_id': responseData['orderId'],
            'name': 'Ecomly',
            'description': 'Order Payment',
            'prefill': {'contact': userData.phone, 'email': userData.email},
            'theme': {'color': '#FF6B35'},
          };

          // Open Razorpay checkout
          _razorpay.open(options);
        } else {
          _showErrorSnackBar(
            responseData['message'] ?? 'Failed to create order',
          );
          setState(() {
            isProcessingPayment = false;
          });
        }
      } else {
        _showErrorSnackBar('Failed to create payment order');
        setState(() {
          isProcessingPayment = false;
        });
      }
    } catch (e) {
      print('Error creating order: $e');
      _showErrorSnackBar('Error creating order');
      setState(() {
        isProcessingPayment = false;
      });
    }
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final userData = ref.watch(userProvider);
    final cartTotal = ref.read(cartProvider.notifier).cartTotal();
    final OrdersController _ordersController = OrdersController();

    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                'Order Summary',
                                style: TextStyle(fontSize: 24),
                              ),
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
                                    Text(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
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
                                      'Change',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                          255,
                                          15,
                                          12,
                                          236,
                                        ),
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
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      print(cartItem.productName);
                      return CartCard(cartModel: cartItem, isCartScreen: false);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Payment Methods',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('Razorpay', style: TextStyle(fontSize: 16)),
                    value: 'razorpay',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Cash on delivery',
                      style: TextStyle(fontSize: 16),
                    ),
                    value: 'cash_on_delivery',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(height: 180),
                ],
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
                    '₹$cartTotal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedPaymentMethod == 'razorpay'
                      ? GestureDetector(
                          onTap: isProcessingPayment
                              ? null
                              : () {
                                  if (userData!.state != '' &&
                                      userData.city != '' &&
                                      userData.postalCode != '' &&
                                      userData.locality != '' &&
                                      userData.phone != '') {
                                    _startRazorpayPayment();
                                  } else {
                                    _showErrorSnackBar(
                                      'Please complete your address before making payment.',
                                    );
                                  }
                                },
                          child: Row(
                            children: [
                              if (isProcessingPayment)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              if (isProcessingPayment) SizedBox(width: 10),
                              Text(
                                isProcessingPayment
                                    ? 'Processing...'
                                    : 'Make Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (userData!.state != '' &&
                                userData.city != '' &&
                                userData.postalCode != '' &&
                                userData.locality != '' &&
                                userData.phone != '') {
                              await Future.forEach(
                                _cartProvider.getCartItems.entries,
                                (entry) {
                                  var item = entry.value;
                                  _ordersController.createOrder(
                                    id: '',
                                    buyerFullName: userData.fullName,
                                    buyerEmail: userData.email,
                                    productName: item.productName,
                                    quantity: item.orderedQuantity,
                                    productPrice: item.productPrice,
                                    category: item.category,
                                    image: item.images[0],
                                    buyerId: userData.id,
                                    vendorId: item.vendorId,
                                    buyerState: userData.state,
                                    buyerCity: userData.city,
                                    buyerLocality: userData.locality,
                                    buyerPhone: userData.phone,
                                    buyerPostalCode: userData.postalCode,
                                    processing: true,
                                    delivered: false,
                                    cancelled: false,
                                    context: context,
                                    productDescription: item.description,
                                    productId: item.productId,
                                  );
                                },
                              );

                              // Clear cart after successful order placement
                              await _clearCart();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderSuccessScreen(),
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
                            'Place Order',
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
