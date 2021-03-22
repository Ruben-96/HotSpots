import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotspots/models/customuser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //Register
  Future register(CustomUser _user) async {
    try{
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: _user.email, password: _user.password);
      _auth.currentUser.updateProfile(displayName: _user.username);
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return e.code;
      } else if (e.code == 'email-already-in-use') {
        return e.code;
      } else if (e.code == 'invalid-email'){
        return e.code;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Sign in
  Future signIn(String userEmail, String userPassword) async {
    assert(userEmail != null);
    assert(userPassword != null);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      User user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  //Sing out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
