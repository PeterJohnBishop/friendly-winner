import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_friendly/images/image_upload.dart';
import 'package:flutter_friendly/images/multi_image_upload.dart';

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
            MultiImagePickerWidget()
          ],
        ),
      ),
    );
  }
}
