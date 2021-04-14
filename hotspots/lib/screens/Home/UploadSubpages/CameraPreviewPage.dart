import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/screens/Home/UploadSubpages/NewPostPage.dart';
import 'package:image_picker/image_picker.dart';

class CameraPreviewPage extends StatefulWidget{

  final User user;
  final List<CameraDescription> cameras;
  final Function setFile;

  CameraPreviewPage(this.user, this.cameras, this.setFile);

  @override
  _CameraPreviewPage createState() => _CameraPreviewPage();

}

class _CameraPreviewPage extends State<CameraPreviewPage>{
  
  CameraController controller;
  XFile file;

  @override
  void initState(){
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max, imageFormatGroup: ImageFormatGroup.jpeg);
    controller.initialize().then((_){
      if(!mounted){
        return;
      }
      setState(() {});
    });
  }
  
  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!controller.value.isInitialized){
      return Container(
        child: Center(
          child: Text("ERROR")
        )
      );
    }
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller)
                    ),
                  )
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container()
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 6.0)),
                          height: 70,
                          width: 70,
                          child: Icon(Icons.camera_outlined, color: Colors.white, size: 54)
                        ),
                        onTap: () async{
                          XFile fileLocation = await controller.takePicture();
                          widget.setFile(fileLocation);
                        },
                      )
                    )
                  ),
                  Expanded(
                    child: IconButton(
                    icon: Icon(Icons.image, size: 32, color: Colors.white),
                    onPressed:() async {
                      PickedFile pickedFile =  await ImagePicker().getImage(source: ImageSource.gallery,);
                      widget.setFile(XFile(pickedFile.path));
                    }
                  )
                  )
                ],
              )
            ],
          ),)
        ],
      )
    );
  }
}