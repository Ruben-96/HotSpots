import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotspots/models/customuser.dart';
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
  XFile fileLocation;
  String postLocation;
  String postCaption;

  @override
  void initState(){
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
    });
  }

  @override
  Widget build(BuildContext context){

    DbService _db = DbService(widget.user);

    if(cameras == null)
    return Container(
      color: Colors.black
    );
    if(fileLocation == null)
    return CameraView(cameras, setFile);
    else
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  child: Text("X", style: TextStyle(fontSize: 24, color: Colors.black),), 
                  onPressed: (){
                    setState((){
                      fileLocation = null;
                    });
                  },
                ),
                Expanded(
                  child: Text("Upload", style: TextStyle(fontSize: 24),),
                ),
                IconButton(
                  icon: Icon(Icons.cloud_upload_outlined), 
                  onPressed: (){
                    _db.uploadPost(fileLocation.name,File(fileLocation.path), postLocation, postCaption);
                    setState((){
                      fileLocation = null;
                    });
                  },
                )
              ],
            ),
            Divider(color: Colors.black),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Column(
                            children: <Widget>[
                              Image.file(File(fileLocation.path))
                            ],
                          )
                        )
                      )
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.location_on_rounded), onPressed: (){},),
                    Expanded(child: TextFormField(decoration: InputDecoration(hintText: "Location"), onChanged: (val){ postLocation = val; },))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Caption..."),
                        maxLines: 8,
                        minLines: 8,
                        onChanged: (val){
                          postCaption = val;
                        },
                      ),
                    )
                  ]
                )
              ],
            )
          ],
        )
      )
    );
  }

  void setFile(XFile file){
    setState((){
      fileLocation = file;
    });
  }

}


class CameraView extends StatefulWidget{

  List<CameraDescription> cameras;
  final setFile;
  CameraView(this.cameras, this.setFile);

  @override
  _CameraView createState() => _CameraView();

}

class _CameraView extends State<CameraView>{
  
  CameraController controller;

  @override
  void initState(){
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
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
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 8.0)),
                          height: 70,
                          width: 70,
                          child: Icon(Icons.camera_outlined, color: Colors.white, size: 32)
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
                      PickedFile pickedFile =  await ImagePicker().getImage(source: ImageSource.gallery);
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

// class UploadPage extends StatefulWidget {
//   _UploadPage createState() => _UploadPage();
// }

// class _UploadPage extends State<UploadPage> {
//   File file;
//   //Strings required to save address
//   Address address;

//   Map<String, double> currentLocation = Map();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   ImagePicker imagePicker = ImagePicker();

//   bool uploading = false;

//   @override
//   initState() {
//     //variables with location assigned as 0.0
//     currentLocation['latitude'] = 0.0;
//     currentLocation['longitude'] = 0.0;
//     initPlatformState(); //method to call location
//     super.initState();
//   }

//   //method to get Location and save into variables
//   initPlatformState() async {
//     Address first = await getUserLocation();
//     setState(() {
//       address = first;
//     });
//   }

//   Widget build(BuildContext context) {

//     return file == null
//         ? IconButton(
//         icon: Icon(Icons.add),
//         onPressed: () => {_selectImage(context)})
//         : Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           backgroundColor: Colors.white70,
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: clearImage),
//           title: const Text(
//             'Post to',
//             style: const TextStyle(color: Colors.black),
//           ),
//           actions: <Widget>[
//             FlatButton(
//                 onPressed: postImage,
//                 child: Text(
//                   "Post",
//                   style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20.0),
//                 ))
//           ],
//         ),
//         body: ListView(
//           children: <Widget>[
//             PostForm(
//               imageFile: file,
//               descriptionController: descriptionController,
//               locationController: locationController,
//               loading: uploading,
//             ),
//             Divider(), //scroll view where we will show location to users
//             (address == null)
//                 ? Container()
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.only(right: 5.0, left: 5.0),
//               child: Row(
//                 children: <Widget>[
//                   buildLocationButton(address.featureName),
//                   buildLocationButton(address.subLocality),
//                   buildLocationButton(address.locality),
//                   buildLocationButton(address.subAdminArea),
//                   buildLocationButton(address.adminArea),
//                   buildLocationButton(address.countryName),
//                 ],
//               ),
//             ),
//             (address == null) ? Container() : Divider(),
//           ],
//         ));
//   }

//   //method to build buttons with location.
//   buildLocationButton(String locationName) {
//     if (locationName != null ?? locationName.isNotEmpty) {
//       return InkWell(
//         onTap: () {
//           locationController.text = locationName;
//         },
//         child: Center(
//           child: Container(
//             //width: 100.0,
//             height: 30.0,
//             padding: EdgeInsets.only(left: 8.0, right: 8.0),
//             margin: EdgeInsets.only(right: 3.0, left: 3.0),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//             child: Center(
//               child: Text(
//                 locationName,
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }

//   _selectImage(BuildContext parentContext) async {
//     return showDialog<Null>(
//       context: parentContext,
//       barrierDismissible: false, // user must tap button!

//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//                 child: const Text('Take a photo'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   PickedFile imageFile =
//                   await imagePicker.getImage(source: ImageSource.camera, maxWidth: 1920, maxHeight: 1200, imageQuality: 80);
//                   setState(() {
//                     file = File(imageFile.path);
//                   });
//                 }),
//             SimpleDialogOption(
//                 child: const Text('Choose from Gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   PickedFile imageFile =
//                   await imagePicker.getImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1200, imageQuality: 80);
//                   setState(() {
//                     file = File(imageFile.path);
//                   });
//                 }),
//             SimpleDialogOption(
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   void clearImage() {
//     setState(() {
//       file = null;
//     });
//   }

//   void postImage() {
//     setState(() {
//       uploading = true;
//     });
//     uploadImage(file).then((String data) {
//       postToFireStore(
//           mediaUrl: data,
//           description: descriptionController.text,
//           location: locationController.text);
//     }).then((_) {
//       setState(() {
//         file = null;
//         uploading = false;
//       });
//     });
//   }
// }

// class PostForm extends StatelessWidget {
//   final imageFile;
//   final TextEditingController descriptionController;
//   final TextEditingController locationController;
//   final bool loading;
//   PostForm(
//       {this.imageFile,
//         this.descriptionController,
//         this.loading,
//         this.locationController});

//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         loading
//             ? LinearProgressIndicator()
//             : Padding(padding: EdgeInsets.only(top: 0.0)),
//         Divider(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             //CircleAvatar(
//             //  backgroundImage: NetworkImage(currentUserModel.photoUrl),
//             //),
//             Container(
//               width: 250.0,
//               child: TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                     hintText: "Write a caption...", border: InputBorder.none),
//               ),
//             ),
//             Container(
//               height: 45.0,
//               width: 45.0,
//               child: AspectRatio(
//                 aspectRatio: 487 / 451,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.fill,
//                         alignment: FractionalOffset.topCenter,
//                         image: FileImage(imageFile),
//                       )),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(Icons.pin_drop),
//           title: Container(
//             width: 250.0,
//             child: TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                   hintText: "Where was this photo taken?",
//                   border: InputBorder.none),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// Future<String> uploadImage(var imageFile) async {
//   var uuid = Uuid().v1();
//   Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
//   UploadTask uploadTask = ref.putFile(imageFile);

//   String downloadUrl = await (await uploadTask).ref.getDownloadURL();
//   return downloadUrl;
// }

// void postToFireStore(
//     {String mediaUrl, String location, String description}) async {
//   var reference = FirebaseFirestore.instance.collection('hotspots_posts');

//   reference.add({
//     "username": "test",//currentUserModel.username, TODO:
//     "location": location,
//     "likes": {},
//     "mediaUrl": mediaUrl,
//     "description": description,
//     "ownerId": "test",//googleSignIn.currentUser.id, TODO:
//     "timestamp": DateTime.now(),
//   }).then((DocumentReference doc) {
//     String docId = doc.id;
//     reference.doc(docId).update({"postId": docId});
//   });
// }