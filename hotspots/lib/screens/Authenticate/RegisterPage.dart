import 'package:firebase_auth/firebase_auth.dart';
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
  String fullName = '';
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
          child: ListView(
            children: <Widget>[Form(
              child: Column(
                children: <Widget>[
                SizedBox(height: 50.0),
                Text("Sign Up", textScaleFactor: 2.0,),
                SizedBox(height: 50.0),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter your full name" : null;
                  }, 
                  onChanged: (val) {
                    setState(() => fullName = val);
                  }, 
                  decoration: InputDecoration(hintText: "Full Name"),),
                SizedBox(height: 20.0),
                TextFormField(validator: (val) {
                  if (val.isEmpty) {
                    return 'Enter an email';
                  }
                  return null;
                }, onChanged: (val) {
                  setState(() => email = val);
                }, decoration: InputDecoration(hintText: "Email"),),
                SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Password must be at least 6 characters.'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }, decoration: InputDecoration(hintText: "Password")),
                SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Password must be at least 6 characters.'
                        : null,
                    onChanged: (val) {
                      setState(() => confirmPassword = val);
                    }, decoration: InputDecoration(hintText: "Confirm Password")),
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
              )
            ),
            SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
            Text("Already have an account?"),
            RaisedButton(
              elevation: 0.0,
              color: Colors.white,
              onPressed: widget.toggleView,
              child: Text("Login", style: TextStyle(color: Colors.blue)))
          ])]
          )
        )
      )
    );
  }
}

// children: <Widget>[
//                 SizedBox(height: 20.0),
//                 TextFormField(validator: (val) {
//                   if (val.isEmpty) {
//                     return 'Enter an email';
//                   }
//                   return null;
//                 }, onChanged: (val) {
//                   setState(() => email = val);
//                 }),
//                 SizedBox(height: 20.0),
//                 TextFormField(
//                     obscureText: true,
//                     validator: (val) => val.length < 6
//                         ? 'Password must be at least 6 characters.'
//                         : null,
//                     onChanged: (val) {
//                       setState(() => password = val);
//                     }),
//                 SizedBox(height: 20.0),
//                 RaisedButton(
//                     color: Colors.green[300],
//                     child: Text(
//                       'Register',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       if (_formKey.currentState.validate()) {
//                         dynamic result = await _auth.register(email, password);
//                         if (result == null) {
//                           setState(
//                               () => error = 'Please provide a valid email.');
//                         }
//                       }
//                     }),
//                 SizedBox(height: 12.0),
//                 Text(
//                   error,
//                   style: TextStyle(color: Colors.red, fontSize: 14.0),
//                 )
//               ],