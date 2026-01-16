import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/favourites/views/favourites_screen.dart';
import 'package:ecomly/home/views/home_screen.dart';
import 'package:ecomly/profile/views/profile_screen.dart';
import 'package:ecomly/orders/views/orders_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _pageIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    OrdersScreen(),
    FavouritesScreen(),
    ProfileScreen(),
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
              Constants.home,
              width: 25,
              color: _pageIndex == 0 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.orders,
              width: 25,
              color: _pageIndex == 1 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.heart,
              width: 25,
              color: _pageIndex == 2 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Constants.profile,
              width: 25,
              color: _pageIndex == 3 ? Pallete.primaryColor : Pallete.greyColor,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
