import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/post.dart';
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
  List<Post> usersPosts = new List<Post>();
  List<Post> taggedPosts = new List<Post>();
  List<Post> pastLocations = new List<Post>();


  @override
  Widget build(BuildContext context){
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Expanded(child: Text(widget.user.displayName, style: TextStyle(fontSize: 24.0,))),
                IconButton(icon: Icon(Icons.settings), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())); },)
              ],
            ),
            Divider(color: Colors.black54, thickness: 1.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                            height: 75,
                            width: 75
                          )
                        )
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(followingCount),
                              Text("Following"),
                            ],
                          )
                        )
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(followersCount),
                              Text("Followers"),
                            ],
                          )
                        )
                      ),
                    ]
                  )
                ],
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,20),
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.red.shade300,
                      toolbarHeight: 50,
                      bottom: TabBar(
                        tabs: <Widget>[
                          Tab(icon: Icon(Icons.portrait_sharp)),
                          Tab(icon: Icon(Icons.tag)),
                          Tab(icon: Icon(Icons.location_on_outlined))
                        ]
                      )
                    ),
                    body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        if(usersPosts.length != 0)
                        GridView.builder(
                          itemCount: usersPosts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3, childAspectRatio: 1),
                          itemBuilder: (BuildContext context, int index){
                            return RaisedButton(
                              child: Text("Post"),
                              onPressed: (){},
                            );
                          },
                        )
                        else
                        Column(children: <Widget>[Expanded(child: Center(child: Text("No posts")))],),
                        if(taggedPosts.length != 0)
                        GridView.builder(
                          itemCount: taggedPosts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3, childAspectRatio: 1),
                          itemBuilder: (BuildContext context, int index){
                            return RaisedButton(
                              child: Text("Post"),
                              onPressed: (){},
                            );
                          },
                        )
                        else
                        Column(children: <Widget>[Expanded(child: Center(child: Text("No tagged posts")))],),
                        if(pastLocations.length != 0)
                        GridView.builder(
                          itemCount: pastLocations.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3, childAspectRatio: 1),
                          itemBuilder: (BuildContext context, int index){
                            return RaisedButton(
                              child: Text("Post"),
                              onPressed: (){},
                            );
                          },
                        )
                        else
                        Column(children: <Widget>[Expanded(child: Center(child: Text("No past locations")))],),
                      ]
                    )
                  )
                ) 
              )
            )
          ],
        )
      )
    );
  }
}