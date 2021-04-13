import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/MessageThreadSettingsPage.dart';

class MessageThreadPage extends StatefulWidget{

  final User user;
  final MessageThread thread;

  MessageThreadPage(this.user, this.thread);

  @override
  _MessageThreadPage createState() => _MessageThreadPage();
}

class _MessageThreadPage extends State<MessageThreadPage>{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference threadIdRef;
  StreamSubscription<DocumentSnapshot> threadInfo;
  StreamSubscription<DocumentSnapshot> messages;

  String threadId;
  String messageContent = "";
  bool newThread = true;
  String previousSender;

  final _key = new GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    if(widget.thread.id == null){
      threadIdRef = _firestore.collection("MessageThreads").doc();
      threadId = threadIdRef.id;
    } else{
      threadId = widget.thread.id;
      newThread = false;
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  String getThreadName(List<CustomUser> members){
    members.sort((a,b) => a.username.compareTo(b.username));
    String threadName = "";
    members.forEach((member) {
      if(!(member.username == widget.user.displayName)){
        threadName += member.username + ", ";
      }
    });
    return threadName.substring(0, threadName.lastIndexOf(","));
  }

  void createThread(List<CustomUser> participants, String messageContent) async{
    Map<String, dynamic> threadMembers = Map<String, dynamic>();
    participants.forEach((member){
      threadMembers[member.uid] = member.username;
    });
    await _firestore.collection("MessageThreads").doc(threadId)
              .set({
                "threadName": null,
                "threadPictureLocation": null,
                "threadMembers": threadMembers,
                "lastMessage": {
                  "content": messageContent,
                  "sender": widget.user.displayName,
                  "time": Timestamp.now(),
                  "openedBy": [widget.user.displayName]
                }
              });
    _firestore.collection("MessageThreads")
              .doc(threadId)
              .collection("threadMessages")
              .add({
                "content": messageContent,
                "sender": widget.user.displayName,
                "time": Timestamp.now()
              });
  }

  void sendMessage(String messageContent){
    _firestore.collection("MessageThreads")
              .doc(threadId)
              .collection("threadMessages")
              .add({
                "content": messageContent,
                "sender": widget.user.displayName,
                "time": Timestamp.now(),
              });
    _firestore.collection("MessageThreads")
              .doc(threadId)
              .update({
                "lastMessage": {
                  "content": messageContent,
                  "sender": widget.user.displayName,
                  "time": Timestamp.now(),
                  "openedBy": [widget.user.displayName]
                }
              });
  }

  @override
  Widget build(BuildContext context){

    return Material(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.red.shade400,
                  height: 75,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 36),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        if(widget.thread.name == null)
                        Expanded(
                          child: Text(getThreadName(widget.thread.participants), style: TextStyle(color: Colors.white, fontSize: 24))
                        )
                        else
                        Expanded(
                          child: Text(widget.thread.name, style: TextStyle(color: Colors.white, fontSize: 24))
                        ),
                        //if(threadId != null)
                        // IconButton(
                        //   icon: Icon(Icons.settings, color: Colors.white, size: 36),
                        //   onPressed: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => MessageThreadSettingsPage(widget.user, widget.thread)));
                        //   },
                        // )
                      ],
                    )
                  ),
                )
              )
            ],
          ),
          if(newThread)
          Expanded(
            child: Center(
                      child: Container(
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
                              child: Icon(Icons.person, size: 36, color: Colors.white)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("Start a conversation", style: TextStyle(fontSize: 18, color: Colors.black45))
                            )
                          ],
                        )
                      )
                    )
          )
          else
          Expanded(
            child: Padding( padding: EdgeInsets.symmetric(horizontal: 10), child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("MessageThreads").doc(threadId).collection("threadMessages").orderBy("time", descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData || snapshot.data.docs.isEmpty) return Center(child: CircularProgressIndicator());
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document){
                    Message message = Message(content: document["content"], sender: document["sender"], time: document["time"].toString());
                    bool display = false;
                    if(previousSender == null){
                      previousSender = document["sender"];
                    } else{
                      display = document["sender"] == previousSender;
                      previousSender = document["sender"];
                    }
                    return MessageBubble(message, 
                                        document["sender"] == widget.user.displayName, 
                                        !display && document["sender"] != widget.user.displayName, 
                                        false);
                  }).toList()
                );
              },
            )
          )),
          Divider(thickness: 1.0, color: Colors.black38,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Form(
                      key: _key,
                      child: TextFormField(
                      autofocus: false,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 4
                        ),
                        hintText: "Message...",
                        fillColor: Colors.black12, 
                        filled: true,
                      ),
                      style: TextStyle(color: Colors.black54,),
                      onChanged: (value){
                        messageContent = value;
                      },
                    )
                    )
                  )
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade400),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 1, vertical: 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue.shade400, style: BorderStyle.solid, width: 2.0), 
                        borderRadius: BorderRadius.circular(20)
                    ))
                  ),
                  child: Text("Send", style: TextStyle(color: Colors.white, fontSize: 14)),
                  onPressed: (){
                    if(messageContent == "" || messageContent == null) return;
                    if(widget.thread.id == null){
                      createThread(widget.thread.participants, messageContent);
                    } else{
                      sendMessage(messageContent);
                    }
                    setState((){
                      _key.currentState.reset();
                      messageContent = "";
                      newThread = false;
                    });
                  },
                )
              ],
            )
          )
        ],
      )
    );
  }
}

class MessageBubble extends StatelessWidget{

  final bool isSender;
  final bool showName;
  final Message message;
  final bool read;

  MessageBubble(this.message, this.isSender, this.showName, this.read);
  @override
  Widget build(BuildContext context){ 
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              if(!isSender && showName)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft, 
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0,2,0,2),
                    child: Text(message.sender)
                  )
                )
              )
            ]
          ),
          Row(
            children: <Widget>[
              if(isSender)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blue),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(message.content, style: TextStyle(color: Colors.white, fontSize: 18))
                        )
                      ),
                      if(read)
                      Text("Read")
                    ],
                  ) 
                )
              )
              else
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.black12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(message.content, style: TextStyle(color: Colors.black))
                        )
                      ),
                    ],
                  )
                )
              )
            ],
          )
        ],
      )
    );
  }
}