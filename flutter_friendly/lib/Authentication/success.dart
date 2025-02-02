import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuccessView extends StatefulWidget {
    final User currentUser;

    SuccessView({required this.currentUser});

    @override
    _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text('Username: ${widget.currentUser.displayName}'),
                        Text('Email: ${widget.currentUser.email}'),
                    ],
                ),
            ),
        );
    }
}