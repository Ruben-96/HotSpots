
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/MessageThreadPage.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/NewMessagePage.dart';
import 'package:hotspots/services/DatabaseContext.dart';

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
    Map<dynamic, dynamic> _threads = new Map<dynamic, dynamic>();
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
              future: _db.getThreads(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                } else{
                  if(snapshot.hasData){
                    _threads = snapshot.data.value;
                  }
                }
                if(_threads != null){
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _threads.length,
                  itemBuilder: (BuildContext context, int index){
                    String threadId = _threads.keys.elementAt(index);
                    String threadName = _threads[threadId]["name"];
                    String threadLastMessage = _threads[threadId]["lastMessage"];
                    String unread = _threads[threadId]["unread"];
                    MessageThread thread = MessageThread(name: threadName, id: threadId, previewMessage: threadLastMessage, unread: unread);
                    return MessageBox(widget.user, thread);
                  },
                );
                } else{
                  return Expanded(child: Center(child: Text("No conversations")));
                }
              }  
            )
          ],
        )
      )
    );
  }
}

class MessageBox extends StatefulWidget{

  final User user;
  final MessageThread thread;

  MessageBox(this.user, this.thread);

  @override
  _MessageBox createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox>{

  @override
  Widget build(BuildContext context){
    return RaisedButton(
      color: Colors.white,
      onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, widget.thread))); },
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
                      children: <Widget>[
                        Text(widget.thread.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                        if(widget.thread.unread == "true")
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          child: Container(
                            height: 10, 
                            width: 10,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                          )
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(widget.thread.previewMessage, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))
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