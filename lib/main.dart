// ignore_for_file: prefer_const_constructors
import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:makeat_app/widgets/globals.dart';
import 'package:makeat_app/widgets/splashscreen.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Flutter execution starts from here
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String path = join(await getDatabasesPath() + "/", "makeatDB.db");
  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    ByteData data = await rootBundle.load("assets/sqlite/makeatDB.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
  sqliteDB = openDatabase(path);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: MyApp(),
      ),
    ),
  );
}
