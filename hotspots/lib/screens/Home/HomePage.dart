import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/post.dart';
import 'package:path/path.dart';


/*
#################################################################
##  Container widget to contain the UI and background widgets  ##
#################################################################
*/
class HomePage extends StatefulWidget {

  final User user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  HomePage(this.user);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  double uiopacity = 1.0;
  int postIndex = 0;

  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseStorage _fireStorage = FirebaseStorage.instance;

  List<Post> posts = <Post>[];

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

  Future<QuerySnapshot> loadPosts(){
    return _fireStore.collection("Posts").limit(10).get();
  }

  @override
  void initState(){
    super.initState();
    loadPosts();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double dragStartLocation;
    double dragEndLocation;

    return Material(
      color: Colors.black,
        child: FutureBuilder(
        future: loadPosts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData || snapshot.data.docs.isEmpty || snapshot.hasError) return Container(color: Colors.black,);
          snapshot.data.docs.forEach((doc) {
            Map<String, dynamic> info = doc.data();
            posts.add(Post(
              postId: info["postId"],
              caption: info["caption"],
              commentsCount: info["commentCount"],
              likesCount: info["likeCount"],
              fileURL: info["fileURL"],
              location: info["location"],
              uploader: info["uploader"]
            ));
          });
          return Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15), top: Radius.zero),
                ),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap:(){
                        toggleUI();
                      },
                      onVerticalDragStart: (details){
                        dragStartLocation = details.localPosition.dy;
                      },
                      onVerticalDragUpdate: (details){
                        dragEndLocation = details.localPosition.dy;
                      },
                      onVerticalDragEnd:(details){
                        if((dragEndLocation - dragStartLocation) > 200){
                          if(postIndex > 0){
                            setState((){
                              postIndex -= 1;
                            });
                          }
                        } else if((dragEndLocation - dragStartLocation) < -200){
                          if(postIndex < posts.length - 1){
                            setState((){
                              postIndex += 1;
                            });
                          }
                        }
                      },
                      child: Image.network(posts.elementAt(postIndex).fileURL, fit: BoxFit.cover,)
                    );
                  },
                )
              ),
              if(posts.isNotEmpty)
              AnimatedOpacity(
                opacity: uiopacity, 
                duration: Duration(milliseconds: 200),
                child: HomeUI(posts.elementAt(postIndex))
              ),
            ]
          );
        }
      )
    );
  }
}

typedef CallBack = void Function(int index);

/*
################################################
## User Interface related to the Home Screen  ##
################################################
*/
class HomeUI extends StatefulWidget{

  Post post;

  HomeUI(this.post);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Column(
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
                      overlayColor: MaterialStateProperty.all<Color>(Colors.red.shade400)
                    ),
                    onPressed: (){

                    },
                  )
                ),
                Expanded(
                  child: TextButton(
                    child: Text("Following", style: TextStyle(color: Colors.white,)),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.red.shade400)
                    ),
                    onPressed: (){
                      
                    },
                  )
                ),
                Expanded(
                  child: TextButton(
                    child: Text("Trending", style: TextStyle(color: Colors.white,)),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.red.shade400)
                    ),
                    onPressed: (){
                      
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
                          onPressed: (){

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
                              Icon(Icons.thumb_up_sharp, color: Colors.white, size: 40),
                              Text(widget.post.likesCount.toString(), style: TextStyle(color: Colors.white))
                            ],
                          ),
                          onPressed: (){
                            FirebaseFirestore.instance.collection("Posts").doc(widget.post.postId).update({
                              "likeCount": widget.post.likesCount + 1
                            });
                            setState((){
                              widget.post.likesCount += 1;
                            });
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
                              Text(widget.post.commentsCount.toString(), style: TextStyle(color: Colors.white))
                            ],
                          ),
                          onPressed: (){

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
                        child: Text(widget.post.uploader, style: TextStyle(color: Colors.white))
                      )
                    ],
                  )
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text(widget.post.caption, style: TextStyle(color: Colors.white)))
                  ],
                )
              ],
            )
          )
        )
      ],
    );
  }
}

class PostDisplay extends StatefulWidget{
  @override
  _PostDisplay createState() => _PostDisplay();
}

class _PostDisplay extends State<PostDisplay>{
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.black,
    );
  }
}

        // Container(
        //   color: Colors.black,
        //   child: ListView.builder(
        //     itemCount: posts.length,
        //     itemBuilder: (BuildContext context, int index){
        //       return FutureBuilder(
        //         future: _fireStorage.ref(posts.elementAt(index).fileLocation).getDownloadURL(),
        //         builder: (BuildContext context, AsyncSnapshot<String> url){
        //           String URL = url.data;
        //           return Image.network(URL);
        //         },
        //       );
        //     },
        //   )
        // ),

// class PostContainer extends StatefulWidget{
  
//   final Post post;

//   PostContainer(this.post);
  
//   @override
//   _PostContainer createState() => _PostContainer();
// }

// class _PostContainer extends State<PostContainer>{

//   String fileURL = "";

//   @override
//   void initState() async{
//     super.initState();
//     fileURL = await FirebaseStorage.instance.ref().child(widget.post.fileLocation).getDownloadURL();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Container(
//       height: 400,
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           Container(
//         ],
//       ),
//     );
//   }
// }