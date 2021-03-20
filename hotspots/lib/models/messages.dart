import 'CustomUser.dart';

class Message{

  final String senderId;
  
  final String senderusername;

  final String content;

  Message(this.senderId, this.senderusername, this.content);

}

class MessageThread{

  final List<CustomUser> participants;

  final List<Message> messages;

  MessageThread(this.participants, this.messages);

}