import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegramclone/modals/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserClass _userFormFirebaseUser(FirebaseUser user) {
    return user != null ? UserClass(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFormFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFormFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPasswordWithEmail(String email) async
  {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e) {
      print(e.toString());
    }
    }

    Future signOut()async
    {
      return await _auth.signOut();
    }
  }

