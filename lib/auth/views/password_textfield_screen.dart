import 'package:ecomly/common/widgets/button.dart';
import 'package:ecomly/auth/controller/auth_controller.dart';
import 'package:ecomly/auth/views/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordTextfieldScreen extends ConsumerStatefulWidget {
  final String email;
  const PasswordTextfieldScreen({super.key, required this.email});

  @override
  ConsumerState<PasswordTextfieldScreen> createState() =>
      _PasswordTextfieldScreenState();
}

class _PasswordTextfieldScreenState extends ConsumerState<PasswordTextfieldScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController _authController = AuthController();
  late String _password;
  bool _obscureText = true;
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    await _authController
        .signInUser(context: context, email: widget.email, password: _password,ref:  ref)
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
          _formKey.currentState!.reset();
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              !_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            loginUser();
                          }
                        },
                        child: ButtonWidget(text: 'Continue'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Forgot password?'),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordScreen();
                                  },
                                ),
                              );
                            },
                            child: Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
