import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_friendly/Items/create_item.dart';

class SuccessView extends StatefulWidget {
  final User currentUser;

  const SuccessView({super.key, required this.currentUser});

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
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => CreateItem()));
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
