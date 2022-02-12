// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/pages/saved.dart';
import "../pages/home.dart";
import "package:firebase_auth/firebase_auth.dart";

User? user = FirebaseAuth.instance.currentUser;

Widget buildBottomBar(BuildContext context) {
  return BottomAppBar(
    color: Colors.white,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(uid: user!.uid)),
            );
          },
          icon: Icon(CupertinoIcons.home, color: Color(0xff3BB143)),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Likes(uid: user!.uid)),
            );
          },
          icon: Icon(CupertinoIcons.hand_thumbsup, color: Color(0xff3BB143)),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.camera_viewfinder,
              color: Colors.transparent), //space holder
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Saved(uid: user!.uid)),
            );
          },
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
