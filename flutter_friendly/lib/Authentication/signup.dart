import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friendly/Authentication/login.dart';
import 'package:flutter_friendly/Authentication/fire_auth.dart';
import 'package:flutter_friendly/Authentication/success.dart';
import 'validator.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameRegisterTextController = TextEditingController();
  final _nameRegisterFocusNode = FocusNode();
  final _emailRegisterTextController = TextEditingController();
  final _emailRegisterFocusNode = FocusNode();

  final _passwordRegisterTextController1 = TextEditingController();
  final _passwordRegisterFocusNode1 = FocusNode();
  final _passwordRegisterTextController2 = TextEditingController();
  final _passwordRegisterFocusNode2 = FocusNode();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _nameRegisterFocusNode.unfocus();
          _emailRegisterFocusNode.unfocus();
          _passwordRegisterFocusNode1.unfocus();
          _passwordRegisterFocusNode2.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ]),
                  TextFormField(
                    autocorrect: false,
                    controller: _nameRegisterTextController,
                    focusNode: _nameRegisterFocusNode,
                    validator: (value) => Validator.validateName(
                      name: value,
                    ),
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _emailRegisterTextController,
                    focusNode: _emailRegisterFocusNode,
                    validator: (value) => Validator.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _passwordRegisterTextController1,
                    focusNode: _passwordRegisterFocusNode1,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                    ),
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _passwordRegisterTextController2,
                    focusNode: _passwordRegisterFocusNode2,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                    ),
                    decoration: InputDecoration(labelText: "Confirm Password"),
                  ),
                  _isProcessing
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                              onPressed: () async {
                                _nameRegisterFocusNode.unfocus();
                                _emailRegisterFocusNode.unfocus();
                                _passwordRegisterFocusNode1.unfocus();
                                _passwordRegisterFocusNode2.unfocus();
                                if (_registerFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  try {
                                    User? user = await FireAuth
                                        .registerUsingEmailPassword(
                                      name: _nameRegisterTextController.text,
                                      email: _emailRegisterTextController.text,
                                      password:
                                          _passwordRegisterTextController2.text,
                                    );

                                    // Handle user after successful registration
                                    if (user != null) {
                                      // Proceed with the user registration success flow
                                      _isProcessing = false;
                                      if (mounted) {
                                        if (context.mounted) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SuccessView(
                                                          currentUser: user)));
                                        }
                                      }
                                    }
                                  } catch (error) {
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                    if (mounted) {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Registration Failed'),
                                            content: Text(error
                                                .toString()), // Display error message
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                              },
                              child: Text("Register"))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
