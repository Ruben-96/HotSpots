import 'package:firebase_auth/firebase_auth.dart';

class CustomUser{

  final String uid;

  final String email;

  final String fullname;

  final String username;

  List<String> postIds;

  CustomUser({this.uid, this.email, this.fullname, this.username});

}