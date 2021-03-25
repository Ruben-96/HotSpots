import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/services/DatabaseContext.dart';

class MessageThreadPage extends StatefulWidget{

  final User user;
  final MessageThread thread;

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
    MessageThread _thread = widget.thread;
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded(child: Text(_thread.name, style: TextStyle(fontSize: 24.0)),)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            if(_thread.id != null)
            Expanded(
              child: FutureBuilder(
                future: _db.getThreadInformation(_thread.id),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.hasData){
                    if(snapshot.data.value == null){
                      return Column(children: <Widget>[Expanded(child: Center(child: Text("No Messages")))],);
                    }
                    _db.sendReadNotification(widget.user, widget.thread.id);
                    List<CustomUser> _participants = new List<CustomUser>();
                    Map<String, String> lastOpenedTimes = new Map<String,String>();
                    snapshot.data.value["participants"].forEach((id, info){ _participants.add(CustomUser.public(id, info["username"])); lastOpenedTimes[info["username"]] = info["lastOpened"]; });
                    _thread.participants = _participants;
                    snapshot.data.value["messages"].forEach((id, messageInfo){
                      messages.add(Message(sender: messageInfo["sender"], time: messageInfo["time"], content: messageInfo["content"]));
                    });
                    bool read = false;
                    messages.sort((a, b) => a.time.compareTo(b.time));
                    String lastSentMessage = messages.lastWhere((message) => message.sender == widget.user.displayName).time;
                    lastOpenedTimes.forEach((user, time){
                      if(time.compareTo(lastSentMessage) >= 0){
                        read = true;
                      }
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index){
                        bool isSender = messages.elementAt(index).sender == widget.user.displayName;
                        bool showName = true;
                        if(index > 0){
                          showName = messages.elementAt(index - 1).sender != messages.elementAt(index).sender;
                        }
                        if(widget.thread.participants.length == 2){
                          showName = false;
                        }
                        if(index == messages.lastIndexWhere((message) => message.sender == widget.user.displayName)){
                          return MessageBubble(messages.elementAt(index), isSender, showName, read);  
                        } else{
                          return MessageBubble(messages.elementAt(index), isSender, showName, false);
                        }
                      },
                    );
                  }
                  return Column(children: <Widget>[Expanded(child: Center(child: CircularProgressIndicator()))]);
                }
              ),
            ),
            if(_thread.id == null)
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
                        },
                      )
                    ),
                    IconButton(icon: Icon(Icons.send),
                      onPressed: (){
                        assert(typedMessage != "");
                        Message _message = Message(sender: widget.user.displayName, time: DateTime.now().toString(), content: typedMessage);
                        _db.sendMessage(_thread, _message);
                        setState((){
                          typedMessage = "";
                          messages = new List<Message>();
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
                          child: Text(message.content, style: TextStyle(color: Colors.white))
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