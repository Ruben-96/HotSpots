
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/screens/Home/MessagesSubpages/MessageThreadPage.dart';
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
  String threadName = "";

  List<CustomUser> followedList = new List<CustomUser>();
  List<CustomUser> selectedList = new List<CustomUser>();
  List<CustomUser> randomList = new List<CustomUser>();

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
                    if(selectedList.length == 1){
                      threadName = selectedList.elementAt(0).username;
                    } else{
                      threadName = "Group Message";
                    }
                    selectedList.add(CustomUser.public(widget.user.uid, widget.user.displayName));
                    MessageThread thread = new MessageThread(participants: selectedList, name: threadName);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, thread)));
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
            if(selectedList.length > 0)
            Container(
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2), 
                child: Center(
                  child: Text("Selected", style: TextStyle(color: Colors.black54,))
                )
              )
            ),
            if(selectedList.length > 0)
            ListView.builder(
              shrinkWrap: true,
              itemCount: selectedList.length,
              itemBuilder: (BuildContext context, int index){
                if(selectedList.elementAt(index).uid == widget.user.uid){
                  return null;
                }
                return UserBox.selected(
                  selectedList.elementAt(index),
                  toggleFromList,
                  true
                );
              }
            ),
            Container(
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2), 
                child: Center(
                  child: Text("People you follow", style: TextStyle(color: Colors.black54,))
                )
              )
            ),
            FutureBuilder(
              future: _db.getFollowedList(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                if(snapshot.hasData){
                  if(snapshot.data.value == null){
                    return Container(
                      height: 100,
                      child: Center(
                        child: Text("You don't follow anyone.")
                      ),
                    );
                  }
                  snapshot.data.value.forEach((name, id){followedList.add(CustomUser.public(id, name)); });
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: followedList.length,
                    itemBuilder: (BuildContext context, int index){
                      if(randomList.elementAt(index).uid != widget.user.uid && !selectedList.contains(randomList.elementAt(index))){
                        return UserBox(
                          followedList.elementAt(index),
                          toggleFromList
                        );
                      }
                      return null;
                    },
                  );
                }
                return CircularProgressIndicator();
              }
            ),
            Container(
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2), 
                child: Center(
                  child: Text("People you may know", style: TextStyle(color: Colors.black54,))
                )
              )
            ),
            FutureBuilder(
              future: _db.getRandomUsers(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                if(snapshot.hasData){
                  if(snapshot.data.value != null){
                    snapshot.data.value.forEach((id, userInfo){ randomList.add(CustomUser.public(id, userInfo["username"])); });
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: randomList.length,
                      itemBuilder: (BuildContext context, int index){
                        if(randomList.elementAt(index).uid != widget.user.uid && !selectedList.contains(randomList.elementAt(index))){
                          return UserBox(
                            randomList.elementAt(index),
                            toggleFromList
                          );
                        }
                        return null;
                      }
                    );
                  }
                }
                return Expanded(child: Center(child: CircularProgressIndicator()));
              }
            )
          ],)
      )
    );
  }

  void toggleFromList(CustomUser user){
    if(selectedList.contains(user)){
      selectedList.remove(user);
    } else{
      selectedList.add(user);
    }
    setState((){
      selectedList = selectedList;
    });
  }

}

class UserBox extends StatelessWidget{

  final CustomUser user;
  final Function toggleFromList;
  final bool selected;

  UserBox(this.user, this.toggleFromList, [this.selected = false]);

  UserBox.selected(this.user, this.toggleFromList, this.selected);

  @override
  Widget build(BuildContext context){
    Color _circleColor = Colors.black12;
    if(selected){
      _circleColor = Colors.blue;
    }
    return RaisedButton(
      color: Colors.white,
      onPressed: (){
        if(selected){
          _circleColor = Colors.black12;
        } else{
          _circleColor = Colors.blue;
        }
        toggleFromList(user);
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
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Text(user.username, style: TextStyle(color: Colors.black87)))
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