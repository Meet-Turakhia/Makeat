// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "../pages/home.dart";
import "package:firebase_auth/firebase_auth.dart";

Widget buildBottomBar(BuildContext context) {
  return BottomAppBar(
    color: Colors.white,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            User? user = FirebaseAuth.instance.currentUser;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(uid: user!.uid)),
            );
          },
          icon: Icon(CupertinoIcons.home, color: Color(0xff3BB143)),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.hand_thumbsup, color: Color(0xff3BB143)),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.camera_viewfinder,
              color: Colors.transparent), //space holder
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.bookmark, color: Color(0xff3BB143)),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.profile_circled, color: Color(0xff3BB143)),
        ),
      ],
    ),
  );
}
