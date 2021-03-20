import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';
import 'package:hotspots/models/post.dart';

class DbService{

  User user;

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _users;
  DatabaseReference _posts;
  DatabaseReference _locations;

  DatabaseReference _user;

  DbService(User user){
    this.user = user;
    _users = _db.reference().child("Users");
    _posts = _db.reference().child("Posts");
    _locations = _db.reference().child("Locations");
    _user = _db.reference().child("Users").child(this.user.uid);
  }

  void createUser(CustomUser user){
    _users.child(user.uid).set({
      'fullname': user.fullname,
      'username': user.username,
      'postIds': {}
    });
  }

  CustomUser getUser(User user){
    final data = _users.child(user.uid).once().then((DataSnapshot snapshot){ Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values){ print(snapshot.value); }); });
    return CustomUser();
  }

  void createPost(Post post, CustomUser user){

  }

  Future<DataSnapshot> getMessages(){
    return _user.child("messages").once();
  }

  void sendMessage(Map<dynamic,dynamic> participants, String threadId, String threadName, String message){
    participants.forEach((key, value){
      _users.child(key).child("messages").child(threadId).child("thread").set({ "message": message });
    });
    _user.child("messages").child(threadId).child("thread").set({ "message": message });
  }

  Future<DataSnapshot> getFollowedList(){
    return _user.child("following").once();
  }

}