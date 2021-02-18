import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotspots/screens/Authenticate/AuthenticatePage.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:provider/provider.dart';

import 'DiscoverPage.dart';
import 'HomePage.dart';
import 'MessagesPage.dart';
import 'ProfilePage.dart';
import 'UploadPage.dart';

class UserWrapper extends StatefulWidget {
  final AuthService _auth = AuthService();

  @override
  _UserWrapper createState() => _UserWrapper();
}

class _UserWrapper extends State<UserWrapper>{

  int currentPage = 0;
  Color navColor = Colors.transparent;
  Color navItemColor = Colors.black;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index){
              if(index == 0){
              setState((){
                navColor = Colors.transparent;
                navItemColor = Colors.white;
                currentPage = index;
              });
              } else{
              setState((){
                navColor = Colors.white;
                navItemColor = Colors.black;
                currentPage = index;
              });
              }
            },
            children: [
              HomePage(),
              DiscoverPage(),
              UploadPage(),
              MessagesPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,
            backgroundColor: navColor,
            selectedItemColor: Colors.red,
            selectedIconTheme: IconThemeData(color: Colors.red),
            unselectedItemColor: navItemColor,
            unselectedIconTheme: IconThemeData(color: this.navItemColor),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPage,
            onTap: (index) {
              if(index == 0){
                setState((){
                  navColor = Colors.red;
                  navItemColor = Colors.white;
                  currentPage = index;
                  _pageController.jumpToPage(currentPage);
                });
              } else{
                setState((){
                  navColor = Colors.white;
                  navItemColor = Colors.black;
                  currentPage = index;
                  _pageController.jumpToPage(currentPage);
                });
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: "Discover"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_rounded),
                label: ""
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded),
                label: "Messages"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Profile"
              )
            ]
          ),
        )
      ],
    );
  }
}