import 'CustomUser.dart';

class Message{

  final String sender;

  final String date;

  final String content;

  Message(this.sender, this.date, this.content);

}

class MessageThread{

  final String name;

  final Map<dynamic,dynamic> participants;

  final List<Message> messages;

  MessageThread(this.name, this.participants, this.messages);

}