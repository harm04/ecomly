import 'package:ecomly/auth/controller/auth_controller.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<VendorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final vendorModel = ref.watch(vendorProvider);
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
                              vendorModel!.vendorFullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              child: Text(vendorModel.vendorFullName[0]),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.shop, size: 18, color: Colors.grey[700]),
                            SizedBox(width: 5),
                            Text(
                              vendorModel.shopName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                accountSettings(Constants.profile, 'Edit Profile'),

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
