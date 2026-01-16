import 'dart:convert';

import 'package:ecomly/auth/views/signin_screen.dart';
import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/common/widgets/nav_bar.dart';
import 'package:ecomly/common/widgets/vendor_nav_bar.dart';
import 'package:ecomly/models/user_model.dart';
import 'package:ecomly/providers/user_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthController {
  //signup user
  Future<void> signUpUser({
    required context,
    required String fullName,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      UserModel userModel = UserModel(
        id: '',
        fullName: fullName,
        email: email,
        password: password,
        city: '',
        state: '',
        locality: '',
        postalCode: '',
        phone: '',
        token: '',
        isAdmin: false,
        isVendor: false,
      );
      http.Response signUpResponse = await http.post(
        Uri.parse('$uri/api/signup'),
        body: userModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      http.Response signInResponse = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: signUpResponse,
        context: context,
        onSuccess: () {
          manageHttpResonse(
            response: signInResponse,
            context: context,
            onSuccess: () async {
              // save the auth token in shared preferences
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String token = jsonDecode(signInResponse.body)['token'];
              await preferences.setString('auth_token', token);
              final userJson = jsonEncode(
                jsonDecode(signInResponse.body)['user'],
              );
              ref.read(userProvider.notifier).setUser(userJson);
              await preferences.setString('userData', userJson);
              //navigate to home screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NavBar()),
                (route) => false,
              );
              showsnackbar(context, 'Account created successfully!');
            },
          );
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  //signin user
  Future<void> signInUser({
    required context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String token = jsonDecode(response.body)['token'];
          await preferences.setString('auth_token', token);
          final userJson = jsonEncode(jsonDecode(response.body)['user']);
          ref.read(userProvider.notifier).setUser(userJson);
          await preferences.setString('userData', userJson);
          //navigate to home screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  //check if user is admin
                  userJson.contains('"isVendor":true')
                  ? VendorNavBar()
                  : NavBar(),
            ),
            (route) => false,
          );
          showsnackbar(context, 'Welcome back!');
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  //signout user
  Future<void> signOutUser({required context,required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('token');
      ref.read(userProvider.notifier).signOut();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInScreen();
          },
        ),
        (route) => false,
      );
      showsnackbar(context, 'Sign out successfull');
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }

  //update user state,city,locality,postal code,phone
  Future<void> updateUserAddress({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required String postalCode,
    required String phone,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.put(
        Uri.parse('${uri}/api/users/$id'),
        body: jsonEncode({
          "state": state,
          "city": city,
          "locality": locality,
          "phone": phone,
          "postalCode": postalCode,
        }),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () async {
          final updatedUser = jsonDecode(response.body);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final userJson = jsonEncode(updatedUser);
          ref.read(userProvider.notifier).setUser(userJson);
          await preferences.setString('userData', userJson);
          showsnackbar(context, "Address saved successfully");
          Navigator.pop(context);
        },
      );
    } catch (error) {
      showsnackbar(context, error.toString());
    }
  }
}
