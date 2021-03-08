import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

class UploadPage extends StatefulWidget{
  @override
  _UploadPage createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage>{
  File _image;
  @override
  Widget build(BuildContext context){
    return Material(
        color: Colors.white,
        child:Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: .0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                    child: Row(
                      children: [
                        Expanded(child: Text("Post Creation", style: TextStyle(fontSize: 24.0)))
                      ],
                    )
                ),
                SizedBox(height: 10.0),
                Divider(color: Colors.black54, thickness: 1.0),
                TextField(
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Post Title'
                  ),
                ),
                _image != null ? Image.asset(
                  _image.path,
                  height: 300,
                ): Placeholder(fallbackHeight : 300),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0)
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: Text('Select a File'),
                        onPressed: chooseFile,
                        color: Colors.black54,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0)
                      ),
                      RaisedButton(
                        child: Text('Create Post'),
                        onPressed: chooseFile,
                        color: Colors.red
                      )]
                )
              ],
            )
        )
    );
  }
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
}

