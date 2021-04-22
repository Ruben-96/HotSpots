import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotspots/models/post.dart';
import 'package:hotspots/screens/Home/UploadSubpages/SelectLocationPage.dart';
import 'package:geolocator/geolocator.dart';

class NewPostPage extends StatefulWidget{

  final User user;
  final XFile file;
  final Function unsetFile;

  NewPostPage(this.user, this.file, this.unsetFile);

  @override
  _NewPostPage createState() => _NewPostPage();
}

class _NewPostPage extends State<NewPostPage>{
  
  Post post;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  void uploadFile(Post post){
    String firebaseLocation = "Posts/" + post.postId;
    FirebaseFirestore.instance.collection("Posts").doc(post.postId).set({
      "caption": post.caption,
      "commentCount": 0,
      "likeCount": 0,
      "location": post.location,
      "latitude": post.lat,
      "longitude": post.long,
      "fileLocation": firebaseLocation,
      "uploader": widget.user.displayName,
      "timestamp": FieldValue.serverTimestamp()
    });
    FirebaseStorage.instance.ref().child(firebaseLocation).putFile(File(widget.file.path));
  }

  void setLocation(String location){
    setState((){
      post.location = location;
    });
  }

  void setCoordinates(double lat, double long) {
    setState((){
      post.lat = lat;
      post.long = long;
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        post.lat = position.latitude;
        post.long = position.longitude;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        post.location =
        "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState(){
    super.initState();
    post = new Post();
    post.postId = FirebaseFirestore.instance.collection("Posts").doc().id;

    _getCurrentLocation();
  }

  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
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
                      TextButton(
                        child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: (){
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                          widget.unsetFile();
                        },
                      ),
                      Expanded(child: Center(child: Text("New Post", style: TextStyle(fontSize: 24, color: Colors.white))),),
                      TextButton(
                        child: Text("Post", style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: (){ 
                          uploadFile(post);
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                          widget.unsetFile();
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
              child: Container(
                color: Colors.black,
                height: 300,
                child: Image.file(File(widget.file.path))
              )
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextFormField(
                  autofocus: false,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Caption...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.black12, 
                    filled: true,
                  ),
                  onChanged: (val){
                    post.caption = val;
                  },
                )
              ),
              Divider(color: Colors.black38, thickness: 1.0, height: 0,),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                ),
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0), child: Icon(Icons.location_on, color: Colors.black87, size: 24),),
                    if(post.location == null || post.location == "")
                    Expanded(child: Text("Location", style: TextStyle(color: Colors.black87, fontSize: 18)))
                    else
                    Expanded(child: Text(post.location, style: TextStyle(color: Colors.black87, fontSize: 18))),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.black87, size: 24)
                  ],
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLocationPage(setLocation)));
                },
              ),
              Divider(color: Colors.black38, thickness: 1.0, height: 0,),
            ]
          )
        )
        ],
      )
    );
  }
}