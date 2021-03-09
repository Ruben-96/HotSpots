import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final DbService _db = DbService();
  final _formKey = GlobalKey<FormState>();
  //Register Values
  String fullName = '';
  String userName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  
  String error = '';
  String fullnameError = '';
  String usernameError = '';
  String emailError = '';
  String passwordError = '';

  String fullnameLabel = '';
  String usernameLabel = '';
  String emailLabel = '';
  String passwordLabel = '';
  String confirmpasswordLabel = '';

  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
              child: Column(
                children: <Widget>[
                SizedBox(height: 50.0),
                Text("Sign Up", textScaleFactor: 2.0,),
                SizedBox(height: 50.0),
                TextFormField(
                  onChanged: (val){
                    if (val.isNotEmpty){
                        fullnameLabel = "Full Name";
                        if (val.contains(new RegExp(r'^.*[0-9].*$'))){
                          fullnameError = "Name can't contain digits.";
                        } else if(val.contains(new RegExp(r'^.*[!@#$%^&*()_+-={}<>,.;].*$'))){
                          fullnameError = "Name can't contain symbols.";
                        } else{
                          fullnameError = "";
                        }
                      } else{
                        fullnameLabel = "";
                      }
                    setState((){
                      fullName = val;
                      fullnameLabel = fullnameLabel;
                      fullnameError = fullnameError;
                    });
                  },
                  decoration: InputDecoration(hintText: "Full Name"),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Row(
                    children: [
                      Text(fullnameLabel, textAlign: TextAlign.left,), 
                      Padding(padding: EdgeInsets.fromLTRB(10,0,0,0), child: Text(fullnameError, style: TextStyle(color: Colors.red, fontSize: 14.0),))
                    ],
                  )
                ),
                TextFormField( 
                  onChanged: (val) {
                    if (val.isNotEmpty){
                        usernameLabel = "Username";
                        if(val.contains(new RegExp(r'^.*[!@#$%^&*()+={}<>,;\s].*$'))){
                          usernameError = "Name can't contain some symbols.";
                        } else{
                          usernameError = "";
                        }
                      } else{
                        usernameLabel = "";
                      }
                    setState((){
                      userName = val;
                      usernameLabel = usernameLabel;
                      usernameError = usernameError;
                    });
                  }, 
                  decoration: InputDecoration(hintText: "Username"),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Row(
                    children: [
                      Text(usernameLabel, textAlign: TextAlign.left,), 
                      Padding(padding: EdgeInsets.fromLTRB(10,0,0,0), child: Text(usernameError, style: TextStyle(color: Colors.red, fontSize: 14.0),))
                    ],
                  )
                ),
                TextFormField(
                  onChanged: (val) {
                    if(val.isNotEmpty){
                      emailLabel = "Email";
                      if(!EmailValidator.validate(val)){
                        emailError = "Enter a valid email.";
                      } else{
                        emailError = "";
                      }
                    } else{
                      emailLabel = "";
                    }
                    setState(() {
                      email = val;
                      emailError = emailError;
                      emailLabel = emailLabel;
                    });
                }, decoration: InputDecoration(hintText: "Email"),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Row(
                    children: [
                      Text(emailLabel, textAlign: TextAlign.left,), 
                      Padding(padding: EdgeInsets.fromLTRB(10,0,0,0), child: Text(emailError, style: TextStyle(color: Colors.red, fontSize: 14.0),))
                    ],
                  )
                ),
                TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      if(val.isNotEmpty){
                        passwordLabel = "Password";
                        passwordError = "";
                        if(val.length < 8) passwordError = "Must be at least 8 characters";
                        if(!val.contains(new RegExp(r'^.*[0-9].*$'))) passwordError = "Password must contain a digit.";
                        if(!val.contains(new RegExp(r'^.*[~`!@#$%^&*()_+-={}:;<>,./?].*$'))) passwordError = "Password must contain a symbol.";
                      } else{
                        passwordLabel = "";
                      }
                      setState((){
                        password = val;
                        passwordLabel = passwordLabel;
                        passwordError = passwordError;
                      });
                    }, decoration: InputDecoration(hintText: "Password")),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Row(
                    children: [
                      Text(passwordLabel, textAlign: TextAlign.left,), 
                      Padding(padding: EdgeInsets.fromLTRB(10,0,0,0), child: Text(passwordError, style: TextStyle(color: Colors.red, fontSize: 14.0,), overflow: TextOverflow.ellipsis))
                    ],
                  )
                ),
                TextFormField(
                    obscureText: true,
                    validator: (val) => val == password
                        ? 'Passwords must match.'
                        : null,
                    onChanged: (val) {
                      setState((){
                        confirmPassword = val;
                        if (confirmPassword != password){
                          error = "Passwords must match";
                        }
                      });
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
                        } else{
                          CustomUser _user = CustomUser(uid: result.uid, fullname: fullName, username: userName);
                          _db.createUser(_user);
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