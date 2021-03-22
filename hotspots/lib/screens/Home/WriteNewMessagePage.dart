
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessageThreadPage.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:uuid/uuid.dart';

class WriteNewMessagePage extends StatefulWidget{

  final User user;
  Map<dynamic, dynamic> selectedList;

  WriteNewMessagePage(this.user, this.selectedList);

  @override
  _WriteNewMessagePage createState() => _WriteNewMessagePage();
}

class _WriteNewMessagePage extends State<WriteNewMessagePage>{
  String message = "";
  String threadName = "";

  @override
  Widget build(BuildContext context){
    DbService _db = DbService(widget.user);
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded( child: getUsernames(widget.selectedList.values.toList())),
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Expanded(child: Container()),
            Row(
              children: <Widget>[
                Expanded( 
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Message..."), 
                    onChanged: (value){
                      setState((){
                        message = value;
                      });
                    },)
                ),
                IconButton(
                  icon: Icon(Icons.send), 
                  onPressed: (){ 
                    if (widget.selectedList.length == 1){
                      threadName = widget.selectedList.values.elementAt(0).toString();
                    } else{
                      threadName = "Group Message";
                    }
                    widget.selectedList[widget.user.uid] = widget.user.displayName;
                    MessageThread thread = MessageThread(threadName, widget.selectedList, new List<Message>());
                    Message _message = Message(widget.user.displayName, DateTime.now().toString(), message);
                    _db.createMessageThread(thread, _message);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, threadId, threadName, message)));
                  }
                )
              ],
            )
          ],
        )
      )
    );
  }

  Widget getUsernames(List<dynamic> names){
    String text = "";
    names.forEach((value){
      text += value;
      text += ", ";
    });
    text = text.substring(0, text.length - 2);
    return new Text(text, style: TextStyle(fontSize: 24), overflow: TextOverflow.ellipsis,);
  }

}