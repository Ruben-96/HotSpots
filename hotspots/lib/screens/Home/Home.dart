import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:video_player/video_player.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HomeUI(),
        BackgroundVideo()
      ]
    );
  }
}

// class Home extends StatelessWidget {
//   final AuthService _auth = AuthService();
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         HomeUI(),
//         BackgroundVideo()
//       ]
//     );
//   }
// }

class HomeUI extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            onPressed: (){ print("Trending"); },
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
      body: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white70, width: 1.0))
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.red,
        selectedIconTheme: IconThemeData(color: Colors.red),
        unselectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.white),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) { print(index); },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Discover"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          )
        ]
      ),
    );
  }
}

class BackgroundVideo extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Material();
  }
}


// class BackgroundVideo extends StatefulWidget{
//   @override
//   _BackgroundVideoState createState() => _BackgroundVideoState();
// }

// class _BackgroundVideoState extends State<BackgroundVideo>{
//   VideoPlayerController _controller;

//   @override
//   void initState(){
//     super.initState();

//   }
  
//   @override
//   Widget build(BuildContext context){

//   }
// }

// return Scaffold(
//         backgroundColor: Colors.blue[100],
//         appBar: AppBar(
//             backgroundColor: Colors.blue[300],
//             elevation: 0.0,
//             title: Text('HotSpots'),
//             actions: <Widget>[
//               FlatButton.icon(
//                   icon: Icon(Icons.person),
//                   label: Text('Logout'),
//                   onPressed: () {
//                     _auth.signOut();
//                   })
//             ]),
//         body: Container(
//             padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//             child: Column(
//               children: [Text('Home Screen')],
//             )));