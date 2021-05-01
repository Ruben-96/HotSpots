import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/screens/Home/UploadSubpages/CameraPreviewPage.dart';
import 'package:hotspots/screens/Home/UploadSubpages/FilePreviewPage.dart';
import 'package:hotspots/screens/Home/UploadSubpages/NewPostPage.dart';
import 'package:hotspots/services/DatabaseContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'location.dart';
import 'package:geocoder/geocoder.dart';

class UploadPage extends StatefulWidget{

  final User user;

  UploadPage(this.user);

  @override
  _UploadPage createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage>{

  List<CameraDescription> cameras;
  XFile file;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void setFile(XFile newFile){
    setState((){
      file = newFile;
    });
  }

  void unsetFile(){
    setState((){
      file = null;
    });
  }

  @override
  Widget build(BuildContext context){

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
    });

    if(cameras == null){
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    if(file == null)
    return CameraPreviewPage(widget.user, cameras, setFile);

    return FilePreviewPage(widget.user, file, unsetFile);
  }
}
