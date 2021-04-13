import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  String query = "";
  MessageThread thread = MessageThread();
  List<String> selectedUsernames = <String>[];
  List<CustomUser> selected = <CustomUser>[];

  @override
  void initState(){
    super.initState();
    selectedUsernames.add(widget.user.displayName);
  }

  @override
  void dispose(){

    super.dispose();
  }

  void toggleFromList(CustomUser user){
    if(selectedUsernames.contains(user.username)){
      setState((){
        selectedUsernames.remove(user.username);
        selected.remove(user);
      });
    } else{
      setState((){
        selectedUsernames.add(user.username);
        selected.add(user);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Material(
      child:Column(
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
                          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 36),
                          onPressed: (){ Navigator.pop(context); },
                        ),
                        Expanded(
                          child: Text(
                            "New Message", 
                            style: TextStyle(
                              fontSize: 24, 
                              color: Colors.white)
                          )
                        ),
                        IconButton(
                          icon: Icon(Icons.message_rounded, color: Colors.white, size: 36),
                          onPressed: (){
                            if(selected.length <= 0) return;
                            selected.add(CustomUser.public(widget.user.uid, widget.user.displayName));
                            thread.participants = selected;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageThreadPage(widget.user, thread))); 
                          },
                        )
                      ],
                    )
                  )
                )
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text("Selected", style: TextStyle(fontSize: 18)),
                )
              )
            ],
          ),
          Divider(color: Colors.black, thickness: 1.0,),
          if(selected != null && selected.isNotEmpty && selectedUsernames.length > 1)
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 100,
                  child:
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selected.length,
                    itemBuilder: (BuildContext context, int index){
                      return SelectedUserContainer(selected.elementAt(index), toggleFromList);
                    },
                  )
                )
              )
            ],
          )
          else
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 100,
                  child: Center(child: Text("No one selected", style: TextStyle(fontSize: 18)))
                )
              )
            ],
          ),
          Divider(color: Colors.black, thickness: 1.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
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
                            onChanged: (val){
                              query = val;
                              setState(() {
                                query = query;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection("Users")
                            .where("username", isGreaterThanOrEqualTo: query)
                            .where("username", isLessThan: query + "z")
                            .where("username", whereNotIn: selectedUsernames)
                            .limit(10)
                            .get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasError || !snapshot.hasData) return new Center(child: CircularProgressIndicator());
                      return GridView.builder(
                        itemCount: snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index){
                          Map<String, dynamic> data = snapshot.data.docs.elementAt(index).data();
                          CustomUser _user = CustomUser.public(data["uid"], data["username"]);
                          return SelectedUserContainer(_user, toggleFromList);
                        },
                      );
                    },
                  )
                )
              )
            ],
          )
    );
  }
}

class SelectedUserContainer extends StatefulWidget{

  final CustomUser user;
  final toggleFromList;

  SelectedUserContainer(this.user, this.toggleFromList);

  @override
  _SelectedUserContainer createState() => _SelectedUserContainer();
}

class _SelectedUserContainer extends State<SelectedUserContainer>{
  
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Container(height: 100, width: 120, child: ElevatedButton(
      onPressed: (){
        widget.toggleFromList(widget.user);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(75)),
      ),
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
                child: Icon(Icons.person, size: 48, color: Colors.white)
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Text(widget.user.username, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))
              )
            )
          ],
        )
      )
    ));
  }
}