import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:hotspots/services/Auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Sign In Values
  String email = '';
  String password = '';
  String error = '';

  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Image.asset('assets/images/logo.png'),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      onChanged: (val) { setState(() => email = val);},
                      decoration: InputDecoration(hintText: "Email")
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      onChanged: (val) {setState(() => password = val);},
                      decoration: InputDecoration(hintText: "Password")
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.green[300],
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                        ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = _auth.signIn(email, password);
                          if (result == null) {
                            setState(() => error = 'Login Failed');
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
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
            Text("Don't have an account?"),
            RaisedButton(
              elevation: 0.0,
              color: Colors.white,
              onPressed: widget.toggleView,
              child: Text("Sign Up", style: TextStyle(color: Colors.blue)))
          ])],
          )
        )
      )
    );
  }
}
