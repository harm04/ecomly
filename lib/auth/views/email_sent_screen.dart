import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/widgets/button.dart';
import 'package:ecomly/auth/views/signin_screen.dart';
import 'package:flutter/material.dart';

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(Constants.emailSent),
              SizedBox(height: 20),
              Text(
                'We Sent you an Email to reset your password.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignInScreen();
                      },
                    ),
                    (route) => false,
                  );
                },
                child: ButtonWidget(text: 'Back to Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
