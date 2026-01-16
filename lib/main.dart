import 'package:ecomly/admin/admin_dashboard.dart';
import 'package:ecomly/auth/views/signin_screen.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/nav_bar.dart';
import 'package:ecomly/common/widgets/vendor_nav_bar.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:ecomly/vendor/controllers/vendor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> NavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    String? userData = preferences.getString('userData');
    if (token != null && userData != null) {
      ref.read(userProvider.notifier).setUser(userData);
      final user = ref.read(userProvider);
      if (user != null && user.isVendor) {
        String? vendorData = preferences.getString('vendorData');
        if (vendorData != null) {
          ref.read(vendorProvider.notifier).setVendor(vendorData);
        } else {
          VendorController vendorController = VendorController();
          await vendorController.fetchVendorData(
            NavigatorKey.currentContext!,
            user.id,
          
          );
        }
      }
    } else {
      ref.read(userProvider.notifier).signOut();
      ref.read(vendorProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ecomly',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Pallete.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(
        future: _checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final user = ref.watch(userProvider);

          return user != null
              ? user.isAdmin
                    ? AdminDashboard()
                    : user.isVendor == true
                    ? VendorNavBar()
                    : NavBar()
              // NavBar()
              : SignInScreen();
        },
      ),
      // home: VendorNavBar(),
    );
  }
}
