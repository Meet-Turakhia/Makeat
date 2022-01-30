import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/services.dart';
import "package:google_sign_in/google_sign_in.dart";
import "../widgets/showtoast.dart";

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignInInstance = GoogleSignIn();

Future<bool> googleSignIn() async {
  try {
    GoogleSignInAccount? googleSignInAccount =
        await googleSignInInstance.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      try {
        await auth.signInWithCredential(credential);
        popupMessage("Login Successful!");
        return Future.value(true);
      } on FirebaseAuthException catch (e) {
        popupMessage(e.code);
        return Future.value(false);
      }
    } else {
      popupMessage("Some Error Occured!");
      return Future.value(false);
    }
  } on PlatformException catch (e) {
    popupMessage(e.code);
    return Future.value(false);
  }
}

Future<bool> signIn(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    popupMessage("Login Successful!");
    return Future.value(true);
  } on FirebaseException catch (e) {
    popupMessage(e.code.toString());
    return Future.value(false);
  }
}

Future<bool> signUp(String email, String password) async {
  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    popupMessage("Account Created Successfully!");
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    popupMessage(e.code.toString());
    return Future.value(false);
  }
}

Future<bool> signOutUser() async {
  User? user = auth.currentUser;
  if (user!.providerData[0].providerId == "google.com") {
    await googleSignInInstance.disconnect();
  }
  await auth.signOut();
  popupMessage("Logout Successful!");
  return Future.value(true);
}
