import 'package:ecomly/auth/controller/auth_controller.dart';
import 'package:ecomly/common/widgets/button.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  late String areaStreet;
  late String flatHouseNo;
  late String city;
  late String state;
  late String postalCode;
  late String phoneNumber;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('Add Address'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //flat, house no., building, company, apartment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Flat, House no., Building, Company, Apartment'),
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
                            return 'Flat, House no., Building, Company, Apartment is required';
                          }
                          return null;
                        },
                        maxLength: 80,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //area, street, sector, village
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Area, Street, Sector, Village'),
                          SizedBox(width: 3),
                          Text('*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) {
                          areaStreet = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Area, Street, Sector, Village is required';
                          }
                          return null;
                        },
                        maxLength: 80,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //state
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('State'),
                          SizedBox(width: 3),
                          Text('*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) {
                          state = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'State is required';
                          }
                          return null;
                        },
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //city/town
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('City/Town'),
                          SizedBox(width: 3),
                          Text('*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) {
                          city = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City/Town is required';
                          }
                          return null;
                        },
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //postal code
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
                            return 'Postal Code is required';
                          }
                          return null;
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //phone number
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
                          phoneNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      //save address button
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthController().updateUserAddress(
                              context: context,
                              id: userData!.id,
                              state: state,
                              city: city,
                              locality: '$flatHouseNo, ${areaStreet}',
                              postalCode: postalCode,
                              phone: phoneNumber,
                              ref: ref
                            );
                            ref.invalidate(userProvider);
                            setState(() {
                              isLoading = false;
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: ButtonWidget(text: 'Save Address'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
