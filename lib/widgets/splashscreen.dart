// ignore_for_file: prefer_const_constructors
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:splashscreen/splashscreen.dart";
import "package:google_fonts/google_fonts.dart";
import "../pages/login.dart";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SplashScreen(
      seconds: 9,
      backgroundColor: Colors.white,
      image: Image.asset(
        "assets/logo/makeat.gif",
      ),
      photoSize: 100.0,
      title: Text("Makeat",
          style:
              GoogleFonts.ubuntu(fontSize: 30.0, fontWeight: FontWeight.bold)),
      loadingText: Text(
        "From \n nCoders",
        style: GoogleFonts.ubuntu(fontSize: 15.0, color: Colors.grey),
        textAlign: TextAlign.center,
      ), //TextStyle(fontFamily: 'Open sans', color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),),
      //styleTextUnderTheLoader: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      useLoader: false,
      navigateAfterSeconds: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Makeat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: LogIn(),
    );
  }
}
