import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/screens/Authenticate/AuthenticatePage.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:provider/provider.dart';
import 'Home/UserWrapper.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DbService _db = DbService(user);
    CustomUser _user = _db.getCustomUser(user);
    if (user == null) {
      return Authenticate();
    } else {
      return UserWrapper(user);
    }
  }
}
