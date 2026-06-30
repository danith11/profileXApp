import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
      
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred with Google Sign-In";
    } catch (e) {
      throw "An unexpected error occurred.";
    }
}

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred";
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred";
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
