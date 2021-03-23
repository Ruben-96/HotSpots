import 'customuser.dart';

class Message{

  String sender;

  String time;

  String content;

  Message({this.sender, this.time, this.content});

}

class MessageThread{

  String id;

  String name;

  List<CustomUser> participants;

  List<Message> messages;

  String previewMessage;

  String unread;

  MessageThread({this.name, this.id, this.participants, this.messages, this.previewMessage, this.unread});

}