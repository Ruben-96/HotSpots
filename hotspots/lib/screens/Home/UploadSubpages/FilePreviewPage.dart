
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/screens/Home/UploadSubpages/NewPostPage.dart';
import 'package:video_player/video_player.dart';

class FilePreviewPage extends StatefulWidget{

  final User user;
  final XFile file;
  final Function unsetFile;

  FilePreviewPage(this.user, this.file, this.unsetFile);

  @override
  _FilePreviewPage createState() => _FilePreviewPage();
}

class _FilePreviewPage extends State<FilePreviewPage>{

  VideoPlayerController _controller;
  Future<void> initializeVideoPlayerFuture;

  @override
  void initState(){
    if(widget.file.name.endsWith(".mp4")){
      print(widget.file.path);
      _controller = VideoPlayerController.file(new File(widget.file.path));
      print(_controller.dataSource);
      initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
    }
    super.initState();
  }

  @override
  void dispose(){
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Container(
      color: Colors.black,
      child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if(widget.file.name.endsWith(".jpg"))
        Column(
          children: <Widget>[
            Expanded(
              child: RotatedBox(
                quarterTurns: 0,
                child: Image.file(File(widget.file.path))
              )
            )
          ]
        )
        else
        Column(
          children: <Widget>[
            Expanded(
              child: RotatedBox(
                quarterTurns: 0,
                child: FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return VideoPlayer(_controller);
                    } else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                )
              )
            )
          ],
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

// class VideoPlayer_ extends StatefulWidget{

//   final XFile file;

//   VideoPlayer_(this.file);

//   @override
//   _VideoPlayer_ createState() => _VideoPlayer_();
// }

// class _VideoPlayer_ extends State<VideoPlayer_>{

//   VideoPlayerController _controller;
//   Future<void> initializeVideoPlayerFuture;

//   @override
//   void initState(){
//     _controller = VideoPlayerController.file(File(widget.file.path));
//     initializeVideoPlayerFuture = _controller.initialize();
//     super.initState();
//   }

//   @override
//   void dispose(){
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context){
//     return FutureBuilder(
//       future: initializeVideoPlayerFuture,
//       builder: (context, snapshot){
//         return VideoPlayer(_controller);
//       }
//     );
//   }
// }