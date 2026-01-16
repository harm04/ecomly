import 'package:ecomly/admin/screens/admin_buyers_screen.dart';
import 'package:ecomly/admin/screens/admin_add_category_screen.dart';
import 'package:ecomly/admin/screens/admin_orders_scree.dart';
import 'package:ecomly/admin/screens/admin_products_screen.dart';
import 'package:ecomly/admin/screens/admin_upload_banner_screen.dart';
import 'package:ecomly/admin/screens/admin_vendors_screen.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget _selectedScreen = AdminVendorsScreen();

  screenNavigator(item) {
    switch (item.route) {
      case AdminVendorsScreen.routeName:
        setState(() {
          _selectedScreen = AdminVendorsScreen();
        });
        break;
      case AdminBuyersScreen.routeName:
        setState(() {
          _selectedScreen = AdminBuyersScreen();
        });
        break;
      case AdminAddCategoryScreen.routeName:
        setState(() {
          _selectedScreen = AdminAddCategoryScreen();
        });
        break;
      case AdminOrdersScreen.routeName:
        setState(() {
          _selectedScreen = AdminOrdersScreen();
        });
        break;
      case AdminUploadBannerScreen.routeName:
        setState(() {
          _selectedScreen = AdminUploadBannerScreen();
        });
        break;
      case AdminProductScreen.routeName:
        setState(() {
          _selectedScreen = AdminProductScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        title: Image.asset(Constants.logo, width: 75),
      ),
      sideBar: SideBar(
        onSelected: (item) {
          screenNavigator(item);
        },

        items: [
          AdminMenuItem(
            title: 'Vendors',
            route: AdminVendorsScreen.routeName,
            icon: CupertinoIcons.person_3_fill,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: AdminBuyersScreen.routeName,
            icon: CupertinoIcons.person_2_fill,
          ),
          AdminMenuItem(
            title: 'Category',
            route: AdminAddCategoryScreen.routeName,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: AdminOrdersScreen.routeName,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'upload Banners',
            route: AdminUploadBannerScreen.routeName,
            icon: CupertinoIcons.upload_circle,
          ),
          AdminMenuItem(
            title: 'Products',
            route: AdminProductScreen.routeName,
            icon: Icons.store,
          ),
        ],
        selectedRoute: AdminVendorsScreen.routeName,
      ),
      body: _selectedScreen,
    );
  }
}
