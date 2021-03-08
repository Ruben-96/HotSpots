import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget{
  @override
  _DiscoverPage createState() => _DiscoverPage();
}

class _DiscoverPage extends State<DiscoverPage>{
  @override
  Widget build(BuildContext context) {
    var list = [{'name':"Adam Aneve","comment":"First!"},
                {'name':"Bob Alice","comment":"I wonder if anyone's listening."},
                {'name':"John Smith","comment":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."},
                {'name':"Richard Bag","comment":"^ loser lol"},
                {'name':"John Smith","comment":"Pardon me sir, but what is it that you just said about me? I'll have you know that I graduated with honors"}];
    return Material(
        color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 5.0),
              Row(children: [
                //TODO WHEN POSTS ARE IMPLEMENTED: ROUTE.
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ print("Return to Post"); },)
              ]),
              Divider(color: Colors.black54, thickness: 1.0),
              Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      for(var item in list )
                        CommentBox(content: item)
                    ],
                  )
              )
            ],
          )
    );
  }
}
class CommentBox extends StatefulWidget{
  final Map<String,String> content;
  CommentBox({Key key, this.content}) : super(key: key);
  @override
  _CommentBox createState() => _CommentBox();
}

class _CommentBox extends State<CommentBox>{
  @override
  Widget build(BuildContext context){
    return RaisedButton(color: Colors.white,onPressed: (){}, elevation: 0.0, child: Container(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12)
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0)),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(5.0,5.0,0.0,0.0),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Text(widget.content['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
                              ],
                            ),
                            Row(
                                children: [
                                  Flexible(
                                      child: Text(widget.content['comment'], overflow: TextOverflow.visible, style: TextStyle(color: Colors.black45))
                                  )
                                ]
                            )
                          ],
                        )
                    )
                )
              ],
            )
        )
    ));
  }
}