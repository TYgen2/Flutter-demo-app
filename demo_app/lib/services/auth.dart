import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user object based on User
  myUser? _userFromUser(User? user) {
    return user != null
        ? myUser(uid: user.uid, isGuest: user.isAnonymous)
        : null;
  }

  // auth change user stream
  Stream<myUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromUser(user));
  }

  // Sign in as a guest
  Future signInAsGuest() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      return _userFromUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & pw
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and pw
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).createEmptyList();

      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future userSignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
