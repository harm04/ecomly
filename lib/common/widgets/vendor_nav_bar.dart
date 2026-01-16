import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/vendor/views/upload_products_screen.dart';
import 'package:ecomly/vendor/views/vendor_earnings_screen.dart';
import 'package:ecomly/vendor/views/vendor_order_screen.dart';
import 'package:ecomly/vendor/views/vendor_profile.dart';
import 'package:flutter/material.dart';

class VendorNavBar extends StatefulWidget {
  const VendorNavBar({super.key});

  @override
  State<VendorNavBar> createState() => _VendorNavBarState();
}

class _VendorNavBarState extends State<VendorNavBar> {
  int _pageIndex = 0;
  final List<Widget> pages = [
    VendorEarningsScreen(),
    UploadProductScreen(),
    VendorProfileScreen(),
    VendorOrderScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },

        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.wallet,
              width: 25,
              color: _pageIndex == 0 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.upload,
              width: 25,
              color: _pageIndex == 1 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.profile,
              width: 25,
              color: _pageIndex == 2 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.orders,
              width: 25,
              color: _pageIndex == 3 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
