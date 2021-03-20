
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:uuid/uuid.dart';

class WriteNewMessagePage extends StatefulWidget{

  final User user;
  final Map<dynamic, dynamic> selectedList;

  WriteNewMessagePage(this.user, this.selectedList);

  @override
  _WriteNewMessagePage createState() => _WriteNewMessagePage();
}

class _WriteNewMessagePage extends State<WriteNewMessagePage>{

  FocusNode _focus = new FocusNode();
  String message = "";
  String threadName = "";
  String threadId = new Uuid().toString();

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
                IconButton(icon: Icon(Icons.send), onPressed: (){ _db.sendMessage(widget.selectedList, threadId, threadName, message); })
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