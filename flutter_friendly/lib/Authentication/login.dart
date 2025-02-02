import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friendly/Authentication/signup.dart';
import 'package:flutter_friendly/Authentication/FireAuth.dart';
import 'package:flutter_friendly/Authentication/success.dart';
import 'validate.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailLoginTextController = TextEditingController();
  final _emailLoginFocusNode = FocusNode();
  final _passwordLoginTextController1 = TextEditingController();
  final _passwordLoginFocusNode1 = FocusNode();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _emailLoginFocusNode.unfocus();
          _passwordLoginFocusNode1.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SignupView()),
                        );
                      },
                      child: Text("SignUp"),
                    ),
                  ]),
                  TextFormField(
                    autocorrect: false,
                    controller: _emailLoginTextController,
                    focusNode: _emailLoginFocusNode,
                    validator: (value) => Validator.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _passwordLoginTextController1,
                    focusNode: _passwordLoginFocusNode1,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                    ),
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  _isProcessing
                      ? CircularProgressIndicator()
                      : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                          onPressed: () async {
                            _emailLoginFocusNode.unfocus();
                            _passwordLoginFocusNode1.unfocus();

                            if (_loginFormKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });
                              User? user =
                                  await FireAuth.signInUsingEmailPassword(
                                email: _emailLoginTextController.text,
                                password: _passwordLoginTextController1.text,
                              ).whenComplete(() => _isProcessing = false);
                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SuccessView()));
                              }
                            }
                          },
                          child: Text("Login"))
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}