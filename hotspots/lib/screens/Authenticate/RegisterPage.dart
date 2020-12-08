import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:hotspots/services/Auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //Register Values
  String email = '';
  String password = '';
  String error = '';

  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
            title: Text('Register'),
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  onPressed: () {
                    widget.toggleView();
                  })
            ]),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(validator: (val) {
                  if (val.isEmpty) {
                    return 'Enter an email';
                  }
                  return null;
                }, onChanged: (val) {
                  setState(() => email = val);
                }),
                SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Password must be at least 6 characters.'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.green[300],
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.register(email, password);
                        if (result == null) {
                          setState(
                              () => error = 'Please provide a valid email.');
                        }
                      }
                    }),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ));
  }
}
