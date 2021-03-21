import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessageThreadPage.dart';
import 'package:hotspots/screens/Home/NewMessagePage.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget{

  final User user;

  MessagesPage(this.user);

  @override
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage>{
  @override
  Widget build(BuildContext context){
    final DbService _db = DbService(widget.user);
    Map<dynamic,dynamic> threads;
    return Material(
      color: Colors.white,
      child:Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Row(
                children: [
                  Expanded(child: Text("Messages", style: TextStyle(fontSize: 24.0))),
                  IconButton(
                    icon: Icon(Icons.person_add), 
                    onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => NewMessagePage(widget.user))); }
                  ),
                ],
              )
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            FutureBuilder(
              future: _db.getMessages(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                } else{
                  if(snapshot.hasData){
                    threads = snapshot.data.value;
                  }
                }
                if(threads != null){
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: threads.length,
                  itemBuilder: (BuildContext context, int index){
                    String threadId = threads.keys.elementAt(index);
                    String threadName = threads[threadId]["name"];
                    String threadLastMessage = threads[threadId]["messages"].values.last["content"].toString();
                    Map<dynamic, dynamic> threadMessages = threads[threadId]["messages"];
                    return MessageBox(widget.user, threadId, threadName, threadLastMessage, threadMessages);
                  },
                );
                } else{
                  return Text("No Messages");
                }
              }  
            )
              // child: ListView(
              //   shrinkWrap: true,
              //   physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              //   children: [
              //     MessageBox("Sandra", "This is a message")
              //   ],
          ],
        )
      )
    );
  }
}

class MessageBox extends StatefulWidget{

  final User user;
  final String threadId;
  final String threadName;
  final String threadPreview;
  Map<dynamic, dynamic> threadMessages;

  MessageBox(this.user, this.threadId, this.threadName, this.threadPreview, this.threadMessages);

  @override
  _MessageBox createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox>{
  @override
  Widget build(BuildContext context){
    return RaisedButton(
      color: Colors.white,
      onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, widget.threadId, widget.threadName, widget.threadMessages))); },
      elevation: 0.0,
      child: Container(
      height: 75.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0,5.0,0.0,0.0),
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text(widget.threadName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.threadPreview, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45))
                        )
                      ]
                    )
                  ],
                )
              )
            )
          ],
        )
      )
    ));
  }
}