
class CustomUser{

  String uid;

  String username;

  String email;

  String password;

  CustomUser.public(this.uid, this.username);

  CustomUser({this.uid, this.email, this.username, this.password}){
    assert(email != null);
    assert(username != null);
  }

}