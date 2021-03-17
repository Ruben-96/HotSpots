import 'package:firebase_database/firebase_database.dart';
import 'package:hotspots/models/customuser.dart';

class DbService{
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _users;
  DatabaseReference _posts;
  DatabaseReference _locations;

  DbService(){
    _users = _db.reference().child("Users");
    _posts = _db.reference().child("Posts");
    _locations = _db.reference().child("Locations");
  }

  void createUser(CustomUser user){
    _users.child(user.uid).set({
      'fullname': user.fullname,
      'username': user.username,
      'postIds': {}
    });
  }

}