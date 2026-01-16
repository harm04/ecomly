import 'package:ecomly/home/widgets/appbar.dart';
import 'package:ecomly/home/widgets/banner.dart';
import 'package:ecomly/products/widgets/popular_product_widget.dart';
import 'package:ecomly/products/widgets/recommended_products_widget.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final userprovider = ref.watch(userProvider);

    if (userprovider == null) {
      setState(() {
        ref.invalidate(userProvider);
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(),
            BannerWidget(),
            RecommendedProductsWidget(),
            Text(userprovider.fullName),
            PopularProductWidget(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
