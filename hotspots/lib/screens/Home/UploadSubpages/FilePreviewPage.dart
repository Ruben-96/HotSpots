
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/screens/Home/UploadSubpages/NewPostPage.dart';

class FilePreviewPage extends StatefulWidget{

  final User user;
  final XFile file;
  final Function unsetFile;

  FilePreviewPage(this.user, this.file, this.unsetFile);

  @override
  _FilePreviewPage createState() => _FilePreviewPage();
}

class _FilePreviewPage extends State<FilePreviewPage>{
  @override
  Widget build(BuildContext context){

    return Container(
      color: Colors.black,
      child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          children: <Widget>[Expanded(
          child: RotatedBox(
            quarterTurns: 0,
            child: Image.file(File(widget.file.path))
          )
        )]
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    height: 75,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 22)),
                            onPressed: (){
                              widget.unsetFile();
                            },
                          ),
                          Expanded(child: Container()),
                          TextButton(
                            child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 22)),
                            onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostPage(widget.user, widget.file, widget.unsetFile))); },
                          )
                        ],
                      )
                    )
                  )
                )
              ],
            )
          ],
        ),
      ],
    ));
  }
}