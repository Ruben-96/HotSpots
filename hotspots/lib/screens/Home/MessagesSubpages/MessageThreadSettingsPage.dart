
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/messages.dart';

class MessageThreadSettingsPage extends StatefulWidget{

  final User user;
  MessageThread thread;

  MessageThreadSettingsPage(this.user, this.thread);

  @override
  _MessageThreadSettingsPage createState() => _MessageThreadSettingsPage();
}

class _MessageThreadSettingsPage extends State<MessageThreadSettingsPage>{

  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose(){

    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Material(
      child: Column(
        children: <Widget>[
          
        ],
      ),
    );
  }
}