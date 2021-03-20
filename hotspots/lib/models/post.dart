import 'dart:io';

class Post{

  final String postId;

  final String creatorId;

  final String creatorUsername;

  final String caption;

  final File data;

  Post({this.postId, this.creatorId, this.creatorUsername, this.caption, this.data});

}