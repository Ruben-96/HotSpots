import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';

class MessagesPage extends StatefulWidget{
  @override
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage>{
  @override
  Widget build(BuildContext context){
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
                  IconButton(icon: Icon(Icons.person_add), onPressed: (){ print("New Message"); },)
                ],
              )
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: [
                  MessageBox(),
                  MessageBox(),
                  MessageBox(),
                  MessageBox(),
                  MessageBox(),
                  MessageBox(),
                  MessageBox(),
                  MessageBox()
                ],
              )
            )
          ],
        )
      )
    );
  }
}

class MessageBox extends StatefulWidget{
  @override
  _MessageBox createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox>{
  @override
  Widget build(BuildContext context){
    return RaisedButton(color: Colors.white,onPressed: (){},elevation: 0.0,child: Container(
      height: 75.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12)
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0,5.0,0.0,0.0),
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text("Name", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("This is a lot of text from a message to test out what the UI looks like if it overflows the box.", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45))
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