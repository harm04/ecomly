import 'dart:convert';

import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/common/widgets/vendor_nav_bar.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:ecomly/vendor/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorController {
  Future<void> sellOnEcomly({
    required BuildContext context,
    required String vendorUserId,
    required String vendorFullName,
    required String vendorEmail,
    required String shopName,
    required String city,
    required String state,
    required String locality,
    required String postalCode,
    required String phone,
  }) async {
    try {
      final VendorModel vendorModel = VendorModel(
        id: '',
        vendorFullName: vendorFullName,
        vendorUserId: vendorUserId,
        vendorEmail: vendorEmail,
        city: city,
        state: state,
        locality: locality,
        postalCode: postalCode,
        phone: phone,
        shopName: shopName,
      );

      final vendorRes = await http.post(
        Uri.parse('$uri/api/switch-to-vendor/${vendorUserId}'),
        body: vendorModel.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      manageHttpResonse(
        response: vendorRes,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final vendorJson = jsonEncode(jsonDecode(vendorRes.body)['vendor']);
          final updatedUserJson = jsonEncode(
            jsonDecode(vendorRes.body)['updatedUser'],
          );
          providerContainer
              .read(userProvider.notifier)
              .setUser(updatedUserJson);
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

          await preferences.setString('vendorData', vendorJson);
          await preferences.setString('userData', updatedUserJson);
          showsnackbar(context, 'Store created successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const VendorNavBar()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print('error in sellOnEcomly: $e');
      showsnackbar(context, 'Error creating store: $e');
    }
  }

  //fetch vendor data
  Future<void> fetchVendorData(
    BuildContext context,
    String vendorUserId,
  ) async {
    try {
      print('Fetching vendor data for userId: $vendorUserId');
      final vendorRes = await http.get(
        Uri.parse('$uri/api/vendor/user/$vendorUserId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Vendor fetch response status: ${vendorRes.statusCode}');
      print('Vendor fetch response body: ${vendorRes.body}');

      manageHttpResonse(
        response: vendorRes,
        context: context,
        onSuccess: () async {
          // Save vendor data to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('vendorData', vendorRes.body);

          providerContainer
              .read(vendorProvider.notifier)
              .setVendor(vendorRes.body);

          print('Vendor data fetched and stored successfully');
          print('Stored vendor data: ${vendorRes.body}');
        },
      );
    } catch (e) {
      print('error in fetchVendorData: $e');
      showsnackbar(context, e.toString());
    }
  }

  Future<List<VendorModel>> fetchVendor() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<VendorModel> vendors = data
            .map((vendor) => VendorModel.fromMap(vendor))
            .toList();
        return vendors;
      } else {
        throw Exception('Failed to load vendors');
      }
    } catch (error) {
      throw Exception('Failed to load vendors: $error');
    }
  }
}
