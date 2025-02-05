import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';

class EntryView extends StatefulWidget {
  const EntryView({super.key});

    @override
    _EntryViewState createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Entry View'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        OutlinedButton(
                            onPressed: () {
                                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignupView()),
  );
                            },
                            child: Text('Sign Up'),
                        ),
                        SizedBox(height: 20),
                        OutlinedButton(
                            onPressed: () {
                                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginView()),
  );
                            },
                            child: Text('Log In'),
                        ),
                    ],
                ),
            ),
        );
    }
}
