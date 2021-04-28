
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/post.dart';
import 'package:hotspots/screens/Home/HomeSubpages/PostCommentsPage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';


/*
#################################################################
##  Container widget to contain the UI and background widgets  ##
#################################################################
*/
class HomePage extends StatefulWidget {

  final User user;

  HomePage(this.user);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  List<Post> posts = <Post>[];

  // void switchFeedView(String feedQuery){
  //   if(feedQuery == "local"){

  //   } else if(feedQuery == "following"){

  //   } else if(feedQuery == "trending"){

  //   }
  // }

  void updateScreen(){

  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15), top: Radius.circular(15)),
        ),
        child: FutureBuilder(
          future: _fireStore.collection("Posts").limit(10).orderBy("timestamp", descending: true).get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError || !snapshot.hasData || snapshot.data.docs.length == 0){
              return Container(
                child: Center(child: CircularProgressIndicator())
              );
            }
            snapshot.data.docs.forEach((doc) {
              Map<String, dynamic> info = doc.data();
              posts.add(new Post(
                postId: doc.id,
                caption: info["caption"],
                fileURL: info["fileURL"],
                likesCount: info["likeCount"],
                likedBy: info["likedBy"],
                commentsCount: info["commentCount"],
                uploader: info["uploader"],
                location: info["location"]
              ));
            });
            return HomeLayout(widget.user, posts, updateScreen);
          }  
        )
      )
    );
  }
}

class HomeLayout extends StatefulWidget{

  final User user;
  final List<Post> posts;
  final Function updateScreen;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeLayout(this.user, this.posts, this.updateScreen);

  @override
  _HomeLayout createState() => _HomeLayout();
}

class _HomeLayout extends State<HomeLayout>{

  int postIndex = 0;
  double uiopacity = 1.0;
  Color likedColor = Colors.white;

  void toggleUI(){
    if (uiopacity == 1.0){
      uiopacity = 0.0;
    } else{
      uiopacity = 1.0;
    }
    setState((){
      uiopacity = uiopacity;
    });
  }

  void toggleLike(){
    if(widget.posts.elementAt(postIndex).likedBy.contains(widget.user.displayName)){
      widget.posts.elementAt(postIndex).likedBy.remove(widget.user.displayName);
      widget.posts.elementAt(postIndex).likesCount--;
      widget._firestore.collection("Posts").doc(widget.posts.elementAt(postIndex).postId).update({
        "likedBy": FieldValue.arrayRemove([widget.user.displayName]),
        "likeCount": FieldValue.increment(-1)
      });
    } else{
      widget.posts.elementAt(postIndex).likedBy.add(widget.user.displayName);
      widget.posts.elementAt(postIndex).likesCount++;
      widget._firestore.collection("Posts").doc(widget.posts.elementAt(postIndex).postId).update({
        "likedBy": FieldValue.arrayUnion([widget.user.displayName]),
        "likeCount": FieldValue.increment(1)
      });
    }
    setState((){
      widget.posts.elementAt(postIndex).likedBy = widget.posts.elementAt(postIndex).likedBy;
      widget.posts.elementAt(postIndex).likesCount = widget.posts.elementAt(postIndex).likesCount;
    });
  }

  @override
  Widget build(BuildContext context){

    User user = Provider.of<User>(context);
    
    if(widget.posts.elementAt(postIndex).likedBy.contains(user.displayName)) likedColor = Colors.red.shade400;
    else likedColor = Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            toggleUI();
          },
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: false,
            itemCount: widget.posts.length,
            onPageChanged: (index){
              setState((){
                postIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index){
              if(widget.posts == null || widget.posts.length == 0){
                return Container(child: Center(child: CircularProgressIndicator(),));
              }
              return Image.network(widget.posts.elementAt(index).fileURL, fit: BoxFit.cover,);
            },
          )
        ),
        AnimatedOpacity(
          opacity: uiopacity, 
          duration: Duration(milliseconds: 200),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black26,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/logo.png", fit: BoxFit.contain, height: 60),
                      Expanded(
                        child: TextButton(
                          child: Text("Local", style: TextStyle(color: Colors.white,)),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                          ),
                          onPressed: uiopacity == 0 ? null : (){
                          },
                        )
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text("Following", style: TextStyle(color: Colors.white,)),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                          ),
                          onPressed: uiopacity == 0 ? null : (){
                          },
                        )
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text("Trending", style: TextStyle(color: Colors.white,)),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                          ),
                          onPressed: uiopacity == 0 ? null : (){
                          },
                        )
                      )
                    ],
                  ),
                )
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10,),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  elevation: MaterialStateProperty.all<double>(0),
                                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.circle, color: Colors.white, size: 40),
                                    Text("+", style: TextStyle(color: Colors.white))
                                  ],
                                ),
                                onPressed: uiopacity == 0 ? null : (){},
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10,),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  elevation: MaterialStateProperty.all<double>(0),
                                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.thumb_up_sharp, color: likedColor, size: 40),
                                    Text(widget.posts.elementAt(postIndex).likesCount.toString(), style: TextStyle(color: Colors.white))
                                  ],
                                ),
                                onPressed: uiopacity == 0 ? null : (){
                                  toggleLike();
                                },
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10,),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  elevation: MaterialStateProperty.all<double>(0),
                                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.comment, color: Colors.white, size: 40),
                                    Text(widget.posts.elementAt(postIndex).commentsCount.toString(), style: TextStyle(color: Colors.white))
                                  ],
                                ),
                                onPressed: uiopacity == 0 ? null : (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostCommentsPage(widget.user, widget.posts.elementAt(postIndex))));
                                },
                              )
                            ),
                          ],
                        )
                      )
                    ],
                  )
                )
              ),
              Container(
                color: Colors.black26,
                height: 150,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(widget.posts.elementAt(postIndex).uploader, style: TextStyle(color: Colors.white))
                            )
                          ],
                        )
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text(widget.posts.elementAt(postIndex).caption, style: TextStyle(color: Colors.white)))
                        ],
                      )
                    ],
                  )
                )
              )
            ]
          )
        ),
      ],
    );
  }
}