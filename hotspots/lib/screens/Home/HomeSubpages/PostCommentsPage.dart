
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/comment.dart';
import 'package:hotspots/models/post.dart';

class PostCommentsPage extends StatefulWidget{

  final User user;
  final Post post;

  PostCommentsPage(this.user, this.post);

  @override
  _PostCommentsPage createState() => _PostCommentsPage();
}

class _PostCommentsPage extends State<PostCommentsPage>{

  final _key = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    String newComment = "";

    return Material(
      child: Column(
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
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 36),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Text("Comments", style: TextStyle(color: Colors.white, fontSize: 24))
                      ],
                    )
                  ),
                )
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Form(
                      key: _key,
                      child: TextFormField(
                      autofocus: false,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 4
                        ),
                        hintText: "Comment",
                        fillColor: Colors.black12, 
                        filled: true,
                      ),
                      style: TextStyle(color: Colors.black54, fontSize: 16,),
                      onChanged: (value){
                        newComment = value;
                      },
                    )
                    )
                  )
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade400),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 1, vertical: 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue.shade400, style: BorderStyle.solid, width: 2.0), 
                        borderRadius: BorderRadius.circular(20)
                    ))
                  ),
                  child: Text("Post", style: TextStyle(color: Colors.white, fontSize: 14)),
                  onPressed: (){
                    if(newComment != "" && newComment != null){
                      FirebaseFirestore.instance.collection("Posts").doc(widget.post.postId).collection("comments").add({
                        "commenterName": widget.user.displayName,
                        "content": newComment,
                        "timestamp": Timestamp.now()
                      });
                      FirebaseFirestore.instance.collection("Posts").doc(widget.post.postId).update({
                        "commentCount": FieldValue.increment(1)
                      });
                      setState(() {
                        newComment = "";
                        _key.currentState.reset();
                      });
                    }
                  },
                )
              ],
            )
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Posts").doc(widget.post.postId).collection("comments").limit(30).orderBy("timestamp", descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError || !snapshot.hasData || snapshot.data.docs.length == 0) return Container(child: Center(child: CircularProgressIndicator())); 
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    Map<String, dynamic> info = snapshot.data.docs.elementAt(index).data();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Row(
                        children: <Widget>[
                          Text(info["commenterName"], style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Text(info["content"], maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87, fontSize: 12))
                          )
                        ],
                      )
                    );
                  },
                );
              },
            )
          )
        ],
      )
    );
  }
}