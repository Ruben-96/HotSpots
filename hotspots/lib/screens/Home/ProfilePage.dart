import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/post.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'ProfileSubpages/SettingsPage.dart';

class ProfilePage extends StatefulWidget{

  final User user;

  ProfilePage(this.user);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{

  String followersCount = "0";
  String followingCount = "0";
  String profilePictureURL;
  List<Post> usersPosts = <Post>[];
  List<Post> taggedPosts = <Post>[];
  List<Post> pastLocations = <Post>[];

  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();

    _fireStore.collection("Users").doc(widget.user.uid).snapshots().listen((snapshot){
      Map<String, dynamic> info = snapshot.data();
      followingCount = info["following"].toString();
      followersCount = info["followers"].toString();

    });

    profilePictureURL = FirebaseStorage.instance.ref("Users/" + widget.user.uid).getDownloadURL().toString();

  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    
    User _user = Provider.of<User>(context);

    return Column(
      children: <Widget>[
        Container(
          height: 75,
          color: Colors.red.shade400,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.user.displayName, style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white, size: 32),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                  },
                )
              ],
            )
          )
        ),
        if(widget.user.photoURL == null)
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26,),
              child: Icon(Icons.person, color: Colors.white, size: 32)
            )
          ),
        )
        else
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 100,
              width: 100,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26,),
              child: Image.network(
                _user.photoURL,
                width: 100,
                fit: BoxFit.cover
              )
            )
          ),
        ),
        Container(
          child: Center(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
              ),
              child: Text("Change Picture"),
              onPressed:() async{
                PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
                String downloadURL;
                await FirebaseStorage.instance.ref("Users/" + widget.user.uid).putFile(File(file.path)).then((snapshot) async{
                  downloadURL = await snapshot.ref.getDownloadURL();
                });
                await widget.user.updateProfile(photoURL: downloadURL);
                setState((){

                });
              }
            )
          )
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.red.shade100)
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(followersCount, style: TextStyle(fontSize: 18)),
                      Text("Followers")
                    ],
                  ),
                  onPressed: (){

                  },
                )
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.red.shade100)
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(followingCount, style: TextStyle(fontSize: 18)),
                      Text("Following")
                    ],
                  ),
                  onPressed: (){

                  },
                )
              )
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red.shade400,
                  toolbarHeight: 50,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(icon: Icon(Icons.portrait_rounded)),
                      Tab(icon: Icon(Icons.tag)),
                      Tab(icon: Icon(Icons.location_on_rounded))
                    ]
                  )
                ),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    if(usersPosts.length != 0)
                    GridView.builder(
                      itemCount: usersPosts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return ElevatedButton(
                          child: Text("Post"),
                          onPressed: (){

                          },
                        );
                      },
                    )
                    else
                    Container(
                      child: Center(
                        child: Text("No posts")
                      )
                    ),
                    if(usersPosts.length != 0)
                    GridView.builder(
                      itemCount: usersPosts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return ElevatedButton(
                          child: Text("Post"),
                          onPressed: (){

                          },
                        );
                      },
                    )
                    else
                    Container(
                      child: Center(
                        child: Text("No posts")
                      )
                    ),
                    if(usersPosts.length != 0)
                    GridView.builder(
                      itemCount: usersPosts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return ElevatedButton(
                          child: Text("Post"),
                          onPressed: (){

                          },
                        );
                      },
                    )
                    else
                    Container(
                      child: Center(
                        child: Text("No posts")
                      )
                    )
                  ],
                ),
              )
            )
          )
        )
      ]
    );
  }
}