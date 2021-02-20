import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{
  final AuthService _auth = AuthService();
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
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded(child: Text("Settings", style: TextStyle(fontSize: 24.0)),)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Row(children: <Widget>[Expanded(child: RaisedButton(child: Text("Logout"), onPressed: (){ _auth.signOut(); Navigator.pop(context); },))],)
          ],)
      )
    );
  }
}