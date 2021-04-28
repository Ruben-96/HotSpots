import 'dart:io';

class Post{

  String postId ="";

  String creatorId = "";

  String uploader = "";

  String caption = "";

  String location = "";

  String fileLocation = "";

  int likesCount = 0;

  int commentsCount = 0;

  String fileURL = "";

  double lat, long;

  List<dynamic> likedBy;

  File data;

  Post({this.postId, this.creatorId, this.uploader, this.caption, this.data, this.location, this.fileLocation,
   this.likesCount, this.commentsCount, this.fileURL, this.likedBy});

}