import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:provider/provider.dart';
import 'SettingsPage.dart';

class ProfilePage extends StatefulWidget{

  final User user;

  ProfilePage(this.user);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Expanded(child: Text("Username", style: TextStyle(fontSize: 24.0,))),
                IconButton(icon: Icon(Icons.settings), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())); },)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0)
          ],
        )
      )
    );
  }
}