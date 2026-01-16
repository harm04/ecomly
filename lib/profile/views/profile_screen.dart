import 'package:ecomly/auth/controller/auth_controller.dart';
import 'package:ecomly/cart/views/add_address_screen.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/widgets/nav_bar.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/vendor/views/sell_on_ecomly_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 250),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userModel!.fullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              child: Text(userModel.fullName[0]),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
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
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(Constants.coupon, height: 20),
                                SizedBox(width: 5),
                                Text('Coupons', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(Constants.help, height: 20),
                                SizedBox(width: 5),
                                Text('Help', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                accountSettings(Constants.profile, 'Edit Profile'),
                GestureDetector(
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
                  child: accountSettings(Constants.location, 'Add Address'),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Earn with Ecomly',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SellOnEcomlyFormScreen();
                        },
                      ),
                    );
                  },
                  child: accountSettings(Constants.shop, 'Sell on Ecomly'),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Feedback & Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                accountSettings(Constants.terms, 'Terms, Policies & Licenses'),
                accountSettings(Constants.faq, 'FAQs'),
                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    //show dialog to confirm logout
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await AuthController().signOutUser(
                                  context: context,
                                  ref: ref,
                                );
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        );
                      },
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
                          'Logout',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 15, 12, 236),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget accountSettings(String icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        Image.asset(icon, height: 20),
        SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 17)),
      ],
    ),
  );
}
