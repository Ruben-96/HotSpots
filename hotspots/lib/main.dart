import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotspots/screens/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hotspots/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return StreamProvider<User>.value(
      value: AuthService().user, child: MaterialApp(home: Wrapper(), debugShowCheckedModeBanner: false,));
  }
}
