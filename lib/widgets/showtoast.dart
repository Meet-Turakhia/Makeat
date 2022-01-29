// ignore_for_file: prefer_const_constructors
import "package:fluttertoast/fluttertoast.dart";
import "package:flutter/material.dart";

void popupMessage(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
