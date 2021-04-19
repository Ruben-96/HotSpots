import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeUI(
        
        ),
      ]
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
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        toolbarHeight: 75.0,
        title: Row(
          children: <Widget>[
            Image.asset("assets/images/logo.png", fit: BoxFit.contain, height: 60)
          ]
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Following", style: TextStyle(color: Colors.white)),
            onPressed: (){ print("Following"); },
          ),
          const Divider(
            color: Colors.white,
            height: 50.0,
            thickness: 5.0,
            indent: 20.0,
            endIndent: 0.0,
          ),
          TextButton(
            child: Text("Trending", style: TextStyle(color: Colors.white)),
            onPressed: () {},
          ),
          const Divider(
            color: Colors.white,
            height: 50.0,
            thickness: 5.0,
            indent: 20.0,
            endIndent: 0.0,
          ),
          TextButton(
            child: Text("Local", style: TextStyle(color: Colors.white)),
            onPressed: (){ print("Local"); },
          ),
          const Divider(
            color: Colors.white,
            height: 10.0,
            thickness: 5.0,
            indent: 20.0,
            endIndent: 0.0,
          ),
        ]
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: FirebaseFirestore.instance.collection("Posts").get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError || !snapshot.hasData) return new Center(child: CircularProgressIndicator());
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index){
                  Map<String, dynamic> info = snapshot.data.docs.elementAt(index).data();
                  //String downloadURI = FirebaseStorage.instance.ref().child(info["fileLocation"]).getDownloadURL();
                  
                  //print(file == null);
                  return null; //Image.file(file);
                },
              );
            }
          )
        ],
      )
    );
  }
}