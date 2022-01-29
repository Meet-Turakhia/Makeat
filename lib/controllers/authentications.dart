import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

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

Future<User?> signIn(String email, String password) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    User? user = result.user;

    return Future.value(user);
  } on FirebaseException catch (e) {
    print(e.code);
  }
}

Future<bool> signUp(String email, String password) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // User? user = result.user;
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "email-already-in-use":
        print("error");
        return Future.value(false);
        break;
      default:
        return Future.value(false);
    }
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
