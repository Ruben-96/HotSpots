import 'package:flutter/material.dart';
import 'package:hotspots/services/Auth.dart';

class UploadPage extends StatefulWidget{
  @override
  _UploadPage createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage>{
  @override
  Widget build(BuildContext context){
    return Material(
      child: Center(
        child: Text("Upload")
      )
    );
  }
}