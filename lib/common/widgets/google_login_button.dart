import 'package:ecomly/common/constants.dart';
import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: Text(
        'Continue with Google',
        style: TextStyle(letterSpacing: 1, fontSize: 16, color: Colors.black),
      ),
      icon: Image.asset(Constants.googlePath, width: 40),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
