import 'package:firebase_database/firebase_database.dart';
import 'package:hotspots/models/customuser.dart';

class DbService{
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _users;

  DbService(){
    _users = _db.reference().child("Users");
  }

  void createUser(CustomUser user){
    _users.child(user.uid).set({
      'fullname': user.fullname,
      'username': user.username
    });
  }

}