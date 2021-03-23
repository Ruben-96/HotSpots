import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hotspots/models/customuser.dart';
import 'package:hotspots/models/messages.dart';

class DbService{

  User user;

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _users;
  //DatabaseReference _posts;
  //DatabaseReference _locations;
  DatabaseReference _messages;

  DatabaseReference _user;

  DbService(User user){
    this.user = user;
    _users = _db.reference().child("Users");
    //_posts = _db.reference().child("Posts");
    //_locations = _db.reference().child("Locations");
    _messages = _db.reference().child("Messages");
    _user = _db.reference().child("Users").child(this.user.uid);
  }

  void createUser(CustomUser user){
    assert(user.username != null);
    assert(user.uid != null);
    _users.child(user.uid).set({
      "username": user.username
    });
  }

  void sendMessage(MessageThread thread, Message message){
    bool newThread = thread.id == null;
    if (thread.id == null){
      thread.id = _messages.push().key;
    }
    var messageId = _messages.child(thread.id).push().key;

    // UPDATING THE USERS INBOX
    thread.participants.forEach((participant){
      if(participant.username == message.sender){
        _users.child(participant.uid).child("inbox").update({
          thread.id:{
            "unread": "false",
            "lastMessage": message.content,
            "name": thread.name
          }
        });
      } else{
        _users.child(participant.uid).child("inbox").update({
          thread.id:{
            "unread": "true",
            "lastMessage": message.content,
            "name": thread.name
          }
        });
      }
    });

    // UPDATING THE MESSAGES THREAD
    if(newThread){
      _messages.child(thread.id).update({
        "name": thread.name,
        "messages": {
          messageId:{
            "sender": message.sender,
            "time": message.time,
            "content": message.content
          }
        }
      });
    } else{
      _messages.child(thread.id).child("messages").update({
        messageId: {
          "sender": message.sender,
          "time": message.time,
          "content": message.content
        }
      });
    }

    // INSERTING ALL THE PARTICIPANTS
    if(newThread){
      thread.participants.forEach((_participant){
        _messages.child(thread.id).child("participants").update({
          _participant.uid: _participant.username
        });
      });
    }
  }

  Future<DataSnapshot> getThreads(){
    return _user.child("inbox").once();
  }

  Future<DataSnapshot> getFollowedList(){
    return _user.child("following").once();
  }

  Future<DataSnapshot> getThreadInformation(String threadId){
    assert(threadId != null);
    return _messages.child(threadId).once();
  }

  Future<DataSnapshot> getRandomUsers(){
    return _users.once();
  }

}