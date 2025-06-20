import 'package:chat_app/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepo {
  final FirebaseAuth auth;

  const AuthRepo({required this.auth});

  bool isUserLogedIn() {
    if (auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  void signOutUser() {
    auth.signOut();
  }

  Future<Response<UserCredential>> loginUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userLogin = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success<UserCredential>(data: userLogin);
    } on FirebaseAuthException catch (e) {
      return Failure(message: firebaseAuthExceptionMessage(e));
    }
  }

  Future<Response<UserCredential>> signupUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success<UserCredential>(data: userCredential);
    } on FirebaseAuthException catch (e) {
      return Failure(message: firebaseAuthExceptionMessage(e));
    }
  }

  Future<bool> resetUserPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (err) {
      debugPrint("Error while reseting user password: $err");
      return false;
    } catch (e) {
      debugPrint("Error while reseting user password: $e");
      return false;
    }
  }
}

String firebaseAuthExceptionMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'This user has been disabled.';
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Wrong password provided.';
    case 'email-already-in-use':
      return 'The email is already in use by another account.';
    case 'operation-not-allowed':
      return 'Operation not allowed. Please contact support.';
    case 'weak-password':
      return 'The password is too weak.';
    default:
      return 'Authentication failed. ${e.message ?? ''}';
  }
}
