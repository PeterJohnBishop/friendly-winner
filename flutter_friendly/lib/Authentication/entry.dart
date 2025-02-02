import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';

class EntryView extends StatefulWidget {
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
                        ElevatedButton(
                            onPressed: () {
                                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignupView()),
  );
                            },
                            child: Text('Sign Up'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
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
