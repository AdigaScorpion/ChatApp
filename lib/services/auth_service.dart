import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // log in
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign up
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      {
        //  call database services to update the user data
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await MyFunctions.saveUserLoggedIn(false);
      await MyFunctions.saveUserNameToSP("");
      await MyFunctions.saveUserEmailToSP("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
