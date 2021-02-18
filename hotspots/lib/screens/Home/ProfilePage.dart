import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return Column(
      
    );
  }
}