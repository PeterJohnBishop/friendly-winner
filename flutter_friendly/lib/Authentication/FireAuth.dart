import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user!.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      // Throw the error for handling on the frontend
      return Future.error(e.message ?? 'Unknown error occurred');
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'Unknown error occurred');
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  // For signing out the user
  static Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  // For getting the current user
  static User? getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user;
  }

  // For updating the user (update required for other properties like image)
  static Future<void> updateUser({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      await user!.updateEmail(email);
      await user.updatePassword(password);
      await user.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'Unknown error occurred');
    }
  }

  // For resetting the password
  static Future<void> resetPassword(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'Unknown error occurred');
    }
  }

  // For deleting the user
  static Future<void> deleteUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      await user!.delete();
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'Unknown error occurred');
    }
  }
}
