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
    });
  }

  Future<String> getUsername(User user) async{
    Future<String> fusername = _user.child("username").once().then((snapshot){ return snapshot.value.toString(); });
    return fusername;
  }

  Future<CustomUser> getCustomUser(User user){
    Future<DataSnapshot> snapshot = _user.once();
    return snapshot;
  }

  CustomUser getPublicUser(User user){
    String username = "";
    Future<String> fusername = _user.child("username").once().then((snapshot){ return snapshot.value.toString(); });
    fusername.then((value){ username = value; });
    return CustomUser.public(user.uid, username);
  }

  void createPost(Post post, CustomUser user){

  }

  void createMessageThread(MessageThread thread, Message message){
    var threadId = _user.child("inbox").push().key;
    var messageId = _user.child("inbox").child(threadId).push().key;
    thread.participants.forEach((uid, username){
      _users.child(uid).child("inbox").child(threadId).set({ "name": thread.name });
      thread.participants.forEach((id, name){
        _users.child(uid).child("inbox").child(threadId).child("participants").set({ id: name});
      });
      _users.child(uid).child("inbox").child(threadId).child("messages").child(messageId).set({
        "sender": message.sender,
        "time": message.date,
        "content": message.content
      });
    });
  }

  Future<DataSnapshot> getMessages(){
    return _user.child("inbox").once();
  }

  void sendMessage(Map<dynamic,dynamic> participants, String threadId, String threadName, String message){
    participants.forEach((key, value){
      _users.child(key).child("messages").child(threadId).set({ "name": threadName });
      _users.child(key).child("messages").child(threadId).child("thread").set({ "message": message });
    });
    _user.child("messages").child(threadId).set({ "name": threadName });
    _user.child("messages").child(threadId).child("thread").set({ "message": message });
  }

  Future<DataSnapshot> getFollowedList(){
    return _user.child("following").once();
  }

}