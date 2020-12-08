import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
            title: Text('Home'),
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Logout'),
                  onPressed: () {
                    _auth.signOut();
                  })
            ]),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: [Text('Home Screen')],
            )));
  }
}
