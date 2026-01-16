import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  const ButtonWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(142, 108, 239, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
