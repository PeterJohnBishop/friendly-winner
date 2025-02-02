import 'package:flutter/material.dart';

class SuccessView extends StatefulWidget {
    @override
    _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text('Success'),
            ),
        );
    }
}