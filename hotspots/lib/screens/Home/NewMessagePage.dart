
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/screens/Home/WriteNewMessagePage.dart';
import 'package:hotspots/services/DatabaseContext.dart';

class NewMessagePage extends StatefulWidget{
  
  final User user;

  NewMessagePage(this.user);
  
  @override
  _NewMessagePage createState() => _NewMessagePage();
}

class _NewMessagePage extends State<NewMessagePage>{

  final _formKey = GlobalKey<FormState>();
  String searchString = "";

  Map<dynamic, dynamic> followedList = new Map<dynamic, dynamic>();
  Map<dynamic, dynamic> selectedList = new Map<dynamic, dynamic>();

  @override
  Widget build(BuildContext context){
    final _db = DbService(widget.user);
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context); },),
                Expanded(child: Text("New Message", style: TextStyle(fontSize: 24.0)),),
                IconButton(
                  icon: Icon(Icons.message_rounded), 
                  onPressed: (){ 
                    assert(selectedList.length > 0);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WriteNewMessagePage(widget.user, selectedList)));
                  })
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0,0,5,0), child: Text("To:")),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Username",),
                          onChanged: (val){
                            setState((){
                              searchString = val;
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
            SizedBox(height: 20.0),
            FutureBuilder(
              future: _db.getFollowedList(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                if(snapshot.hasData){
                  if(snapshot.data.value == null){
                    return Text("You don't follow anyone.");
                  }
                  followedList = snapshot.data.value;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: followedList.length,
                    itemBuilder: (BuildContext context, int index){
                      String username = followedList.keys.elementAt(index);
                      String userId = followedList[username].toString();
                      return UserBox(
                        userId,
                        username,
                        toggleFromList
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              }
            )
          ],)
      )
    );
  }

  void toggleFromList(String userId, String userName){
    if(selectedList.containsKey(userId)){
      selectedList.remove(userId);
    } else{
      selectedList[userId] = userName;
    }
  }

}

class UserBox extends StatefulWidget{

  final userId;
  final userName;
  final Function toggleFromList;

  UserBox(this.userId, this.userName, this.toggleFromList);

  @override
  _UserBox createState() => _UserBox();
}

class _UserBox extends State<UserBox>{

  bool selected = false;
  Color _circleColor = Colors.black12;

  @override
  Widget build(BuildContext context){
    return RaisedButton(
      color: Colors.white,
      onPressed: (){
        if(selected){
          _circleColor = Colors.black12;
        } else{
          _circleColor = Colors.blue;
        }
        setState((){
          selected = !selected;
          _circleColor = _circleColor;
          widget.toggleFromList(widget.userId, widget.userName);
        });
      },
      elevation: 0,
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
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Text(widget.userName, style: TextStyle(color: Colors.black87)))
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(shape: BoxShape.circle, color: _circleColor),
              )
            ],
          )
        )
      )
    );
  }
}