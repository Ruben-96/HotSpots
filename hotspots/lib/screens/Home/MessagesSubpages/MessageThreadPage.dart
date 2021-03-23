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
                    List<CustomUser> _participants = new List<CustomUser>();
                    snapshot.data.value["participants"].forEach((id, name){ _participants.add(CustomUser.public(id, name));});
                    _thread.participants = _participants;
                    snapshot.data.value["messages"].forEach((id, messageInfo){
                      messages.add(Message(sender: messageInfo["sender"], time: messageInfo["time"], content: messageInfo["content"]));
                    });
                    messages.sort((a, b) => a.time.compareTo(b.time));
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index){
                        bool isSender = messages.elementAt(index).sender == widget.user.displayName;
                        bool showName = true;
                        if(index > 0){
                          showName = messages.elementAt(index - 1).sender != messages.elementAt(index).sender;
                        }
                        return MessageBubble(messages.elementAt(index), isSender, showName);
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
                          messages.removeRange(0, messages.length - 1);
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

  MessageBubble(this.message, this.isSender, this.showName);

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
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.blue),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(message.content, style: TextStyle(color: Colors.white))
                    )
                  ) 
                )
              )
              else
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.blue),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(message.content, style: TextStyle(color: Colors.white))
                    )
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