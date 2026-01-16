import 'package:flutter/material.dart';

class AdminProductScreen extends StatelessWidget {
  static const String routeName = '/products';
  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Products Screen')));
  }
}
