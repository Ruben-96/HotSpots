import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotspots/screens/Authenticate/AuthenticatePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Home/UserWrapper.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return UserWrapper(user);
    }
  }
}
