import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/button.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/vendor/controllers/vendor_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellOnEcomlyFormScreen extends ConsumerStatefulWidget {
  const SellOnEcomlyFormScreen({super.key});

  @override
  ConsumerState<SellOnEcomlyFormScreen> createState() =>
      _SellOnEcomlyFormScreenState();
}

class _SellOnEcomlyFormScreenState
    extends ConsumerState<SellOnEcomlyFormScreen> {
  bool isLoading = false;
  late String shopName;
  late String state;
  late String city;
  late String flatHouseNo;
  late String streetArea;
  late String postalCode;
  late String phone;
  PageController pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VendorController vendorController = VendorController();

  //sell on ecomly function
  Future<void> sellOnEcomly({
    required BuildContext context,
    required String vendorFullName,
    required String vendorUserId,
    required String vendorEmail,
    required String city,
    required String state,
    required String streetArea,
    required String flatHouseNo,
    required String postalCode,
    required String phone,
    required String shopName,
  }) async {
    setState(() {
      isLoading = true;
    });

    await vendorController.sellOnEcomly(
      context: context,

      vendorFullName: vendorFullName,
      vendorUserId: vendorUserId,
      vendorEmail: vendorEmail,
      city: city,
      state: state,
      locality: '$flatHouseNo, $streetArea',
      postalCode: postalCode,
      phone: phone,
      shopName: shopName,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Add this
                      children: [
                        SizedBox(
                          height: 50,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Create your store on Ecomly',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 0.002, color: Pallete.greyColor),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Shop details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text('*', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            Text(
                              '0/5', // Fixed the undefined variable
                              style: TextStyle(color: Pallete.greyColor),
                            ),
                          ],
                        ),

                        //shop name
                        SizedBox(height: 20),

                        // Fix this problematic Row - remove it and just use Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                shopName = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter shop name';
                                }
                                return null;
                              },
                              maxLength: 50,
                              decoration: InputDecoration(
                                hintText: 'Enter shop name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Text(
                              'Shop name will be visible to customers. Choose a name that reflects your brand.',
                              style: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),

                        //shop state
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Shop Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Flat/House No'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),

                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            flatHouseNo = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Flat/House No';
                            }
                            return null;
                          },
                          maxLength: 80,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Flat/House No',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Add spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Street/Area'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),

                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            streetArea = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Street/Area';
                            }
                            return null;
                          },
                          maxLength: 80,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Street/Area',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        SizedBox(height: 10), // Add spacing
                        //shop city
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('City'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),

                        SizedBox(height: 10), // Add spacing
                        TextFormField(
                          onChanged: (value) {
                            city = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter city';
                            }
                            return null;
                          },
                          maxLength: 20,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter city',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        SizedBox(height: 10), // Add spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('State'), // Fixed typo from 'Sate' to 'State'
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10), // Add spacing
                        TextFormField(
                          onChanged: (value) {
                            state = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter state';
                            }
                            return null;
                          },
                          keyboardType:
                              TextInputType.text, // Changed from multiline
                          maxLength: 20,
                          decoration: InputDecoration(
                            hintText: 'Enter state',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Add spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Postal Code'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),

                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            postalCode = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Postal Code';
                            }
                            return null;
                          },
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Postal Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Add spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Phone Number'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),

                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            phone = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Phone Number';
                            }
                            return null;
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.phone, // Changed to phone
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await sellOnEcomly(
                                context: context,
                                vendorFullName: user!.fullName,
                                vendorUserId: user.id,
                                vendorEmail: user.email,
                                city: city,
                                state: state,
                                streetArea: streetArea,
                                flatHouseNo: flatHouseNo,
                                postalCode: postalCode,
                                phone: phone,
                                shopName: shopName,
                              );
                            }
                          },
                          child: ButtonWidget(text: 'Create your store'),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
