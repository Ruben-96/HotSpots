
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/services/DatabaseContext.dart';

class MessageThreadPage extends StatefulWidget{

  final User user;
  final String threadId;
  final String threadName;

  MessageThreadPage(this.user, this.threadId, this.threadName);

  @override
  _MessageThreadPage createState() => _MessageThreadPage();
}

class _MessageThreadPage extends State<MessageThreadPage>{

  GlobalKey _formKey = GlobalKey();
  String message = "";

  @override
  Widget build(BuildContext context){
    DbService _db = DbService(widget.user);
    Map<dynamic, dynamic> messages = new Map<dynamic, dynamic>();
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded(child: Text(widget.threadName, style: TextStyle(fontSize: 24.0)),)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Expanded(
              child: FutureBuilder(
                future: _db.getThreadMessages(widget.threadId),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.hasData){
                    if(snapshot.data.value == null){
                      return Expanded(child: Center(child: Text("No Messages")));
                    }
                    messages = snapshot.data.value;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index){
                        String sender = messages.values.elementAt(index)["sender"];
                        String content = messages.values.elementAt(index)["content"];
                        bool isSender = sender == widget.user.displayName;
                        return MessageBubble(sender, content, isSender);
                      },
                    );
                  }
                  return CircularProgressIndicator();
                }
              ),
            ),
            Container(
              child: Form(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(decoration: InputDecoration(hintText: "Message..."),
                      onChanged: (value){
                        setState(() {
                          message = value;
                        });
                      },)
                    ),
                    IconButton(icon: Icon(Icons.send),
                      onPressed: (){
                        assert(message != "");
                        _db.sendMessage(widget.threadId, message);
                      },)
                  ],
                )
              )
            )
          ],
        )
      )
    );
  }
}

class MessageBubble extends StatelessWidget{

  bool isSender;
  String sender;
  String content;

  MessageBubble(this.sender, this.content, this.isSender);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(sender))
            ]
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.blue),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(content, style: TextStyle(color: Colors.white))
                )
              )
            ],
          )
        ],
      )
    );
  }
}