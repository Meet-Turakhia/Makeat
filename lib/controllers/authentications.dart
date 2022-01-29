import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "../widgets/showtoast.dart";

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignInInstance = GoogleSignIn();

Future<bool> googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount =
      await googleSignInInstance.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User? user = auth.currentUser;

    print(user!.uid);

    return Future.value(true);
  } else {
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
  if (user!.providerData[1].providerId == "google.com") {
    await googleSignInInstance.disconnect();
  }
  await auth.signOut();
  return Future.value(true);
}
