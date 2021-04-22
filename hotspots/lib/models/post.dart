import 'dart:io';

class Post{

  String postId;

  String creatorId;

  String creatorUsername;

  String caption;

  String location;

  double lat, long;

  File data;

  Post({this.postId, this.creatorId, this.creatorUsername, this.caption, this.data});

}