// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:makeat_app/pages/home.dart';
import 'package:makeat_app/pages/login.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          return LoginPage(uid: user!.uid);
        } else {
          return LogIn();
        }
      },
    );
  }
}
