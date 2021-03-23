
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/services/DatabaseContext.dart';

class MessageThreadPage extends StatefulWidget{

  User user;
  MessageThread thread;

  MessageThreadPage(this.user, this.thread);

  @override
  _MessageThreadPage createState() => _MessageThreadPage();
}

class _MessageThreadPage extends State<MessageThreadPage>{

  String typedMessage = "";
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    DbService _db = DbService(widget.user);
    List<Message> messages = new List<Message>();
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded(child: Text(widget.thread.name, style: TextStyle(fontSize: 24.0)),)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            if(widget.thread.id != null)
            Expanded(
              child: FutureBuilder(
                future: _db.getThreadInformation(widget.thread.id),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.hasData){
                    if(snapshot.data.value == null){
                      return Expanded(child: Center(child: Text("No Messages")));
                    }
                    List<CustomUser> _participants = new List<CustomUser>();
                    snapshot.data.value["participants"].forEach((id, name){ _participants.add(CustomUser.public(id, name));});
                    widget.thread.participants = _participants;
                    snapshot.data.value["messages"].forEach((id, messageInfo){
                      messages.add(Message(sender: messageInfo["sender"], time: messageInfo["time"], content: messageInfo["content"]));
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index){
                        bool isSender = messages.elementAt(index).sender == widget.user.displayName;
                        return MessageBubble(messages.elementAt(index), isSender);
                      },
                    );
                  }
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                }
              ),
            ),
            if(widget.thread.id == null)
            Expanded(
              child: Center(
                child: Text("Start a new conversation")
              )
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Message..."),
                        onChanged: (value){
                          typedMessage = value;
                          setState((){
                            typedMessage = typedMessage;
                          });
                        },
                      )
                    ),
                    IconButton(icon: Icon(Icons.send),
                      onPressed: (){
                        assert(typedMessage != "");
                        Message _message = Message(sender: widget.user.displayName, time: DateTime.now().toString(), content: typedMessage);
                        _db.sendMessage(widget.thread, _message);
                        setState((){
                          typedMessage = "";
                          _formKey.currentState.reset();
                        });
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
  Message message;

  MessageBubble(this.message, this.isSender);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(message.sender))
            ]
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.blue),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(message.content, style: TextStyle(color: Colors.white))
                )
              )
            ],
          )
        ],
      )
    );
  }
}