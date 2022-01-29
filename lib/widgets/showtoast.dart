// ignore_for_file: non_constant_identifier_names
import "package:fluttertoast/fluttertoast.dart";
import "package:flutter/material.dart";

void popupMessage() {
  Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
