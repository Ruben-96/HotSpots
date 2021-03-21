import 'package:firebase_auth/firebase_auth.dart';

class CustomUser{

  final String uid;

  final String username;

  String fullname;

  String email;

  CustomUser.public(this.uid, this.username);

  CustomUser({this.uid, this.email, this.fullname, this.username});

}