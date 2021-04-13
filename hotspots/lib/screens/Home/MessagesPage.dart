
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/MessageThreadPage.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/NewMessagePage.dart';

class MessagesPage extends StatefulWidget{
  final User user;

  MessagesPage(this.user);

  @override
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage>{

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){

    super.dispose();
  }

  String getThreadName(Map<String, dynamic> members){
    String threadName = "";
    members.forEach((key, value) {
      if(!(value == widget.user.displayName)){
        threadName += value + ", ";
      }
    });
    return threadName.substring(0, threadName.lastIndexOf(","));
  }

  @override
  Widget build(BuildContext context){
    return Column(
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
                      Expanded(child: Text("Messages", style: TextStyle(fontSize: 24, color: Colors.white)),),
                      IconButton(
                        icon: Icon(Icons.group_add, color: Colors.white, size: 36), 
                        onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => NewMessagePage(widget.user))); },
                      )
                    ],
                  )
                )
              )
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5.0),
          child: Container(
            height: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.red.shade100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Icon(Icons.search, color: Colors.black54)
                  ),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                      ), 
                      decoration: InputDecoration(
                        hintText: "Search", 
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("MessageThreads")
                                                .where("threadMembers." + widget.user.uid, isEqualTo: widget.user.displayName)
                                                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError || !snapshot.hasData || snapshot.data.docs.isEmpty) return new Container(child: Center(child: Text("No conversations", textDirection: TextDirection.ltr,)));
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document){
                    String threadName = document["threadName"] == null ? getThreadName(document["threadMembers"]) : document["threadName"];
                    return new ThreadContainer(user: widget.user, name: threadName, lastMessage: document["lastMessage"], id: document.id, openedBy: document["lastMessage"]["openedBy"]);
                  }).toList()
                );
              },
            )
          )
        )
      ],
    );
  }
}

class ThreadContainer extends StatefulWidget{

  User user;
  String name;
  String id;
  Map<String, dynamic> lastMessage;
  List<dynamic> openedBy;

  ThreadContainer({this.user, this.name, this.id, this.lastMessage, this.openedBy});

  @override
  _ThreadContainer createState() => _ThreadContainer();
}

class _ThreadContainer extends State<ThreadContainer>{

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(75)),
      ),
      onPressed: (){ 
        MessageThread thread = new MessageThread(id: widget.id, name: widget.name);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, thread))); 
      },
      child: Container(
        child: Row(
          children: <Widget>[
            if(!widget.openedBy.contains(widget.user.displayName))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45, border: Border.all(color: Colors.red.shade300, width: 3.0)),
                child: Icon(Icons.person, size: 36)
              ),
            )
            else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45,),
                child: Icon(Icons.person, size: 36)
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.name, 
                          style: TextStyle(
                            color: Colors.black87
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      if(widget.openedBy.contains(widget.user.displayName))
                      Expanded(
                        child: Text(
                          widget.lastMessage["content"],
                          style: TextStyle(
                            color: Colors.black45
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                      )
                      else
                      Expanded(
                        child: Text(
                          widget.lastMessage["content"],
                          style: TextStyle(
                            color: Colors.black54
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                      )
                    ],
                  )
                ],
              )
            )
            
          ],
        )
      ),
    );
  }

}