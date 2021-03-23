
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
##########################
###  Upload Page Code  ###
##########################
*/
class UploadPage extends StatefulWidget{

  final User user;

  UploadPage(this.user);

  @override
  _UploadPage createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage>{

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Upload Page")
      )
    );
  }

}

/*
################################################
###  Camera preview working with code below  ###
################################################
// 
*/
// class _UploadPage extends State<UploadPage>{

//   CameraController _controller;

//   String route = "/camera";

//   @override
//   Widget build(BuildContext context){
//     return Stack(
//       children: [
//         MaterialApp(
//           initialRoute: route,
//           routes: {
//             '/camera': (BuildContext ctx) => _Camera(_controller),
//             '/gallery': (BuildContext ctx) => _Gallery(_controller)
//           }
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//           child: Row(
//             children: [
//               ElevatedButton(child: Text("Capture", style:TextStyle(color: Colors.white)), onPressed: (){ setState((){ route = "/gallery"; });},)
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// /*
// ######################################
// ###  Camera to capture images code ###
// ######################################
// */
// class _Camera extends StatefulWidget{
//   final loadingWidget;
//   @override
//   _Camera(this.loadingWidget);

//   _CameraState createState() => _CameraState();
// }

// class _CameraState extends State<_Camera> with WidgetsBindingObserver{

//   List<CameraDescription> _cameras;
//   CameraController _controller;
//   int _camIdx = 0;
  
//   @override
//   void initState(){
//     super.initState();
//     setupCamera();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose(){
//     WidgetsBinding.instance.addObserver(this);
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       if (widget.loadingWidget != null) {
//         return widget.loadingWidget;
//       } else {
//         return Container(
//           color: Colors.black,
//         );
//       }
//     } else {
//       return CameraPreview(_controller);
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (_controller == null || !_controller.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       setupCamera();
//     }
//   }

//   Future<void> setupCamera() async{
//     _cameras = await availableCameras();
//     var controller = await selectCamera();
//     setState(() => _controller = controller);
//   }

//   selectCamera() async{
//     var controller = CameraController(_cameras[_camIdx], ResolutionPreset.low);
//     await controller.initialize();
//     return controller;
//   }

//   toggleCamera() async {
//     int newSelected = (_camIdx + 1) % _cameras.length;
//     _camIdx = newSelected;
    
//     var controller = await selectCamera();
//     setState(() => _controller = controller);
//   }
// }

// /*
// #############################
// ###  Gallery Widget code  ###
// #############################
// */
// class _Gallery extends StatefulWidget{
//   final loadingWidget;
//   _Gallery(this.loadingWidget);
//   @override
//   _GalleryState createState() => _GalleryState();
// }

// class _GalleryState extends State<_Gallery>{
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp();
//   }
// }