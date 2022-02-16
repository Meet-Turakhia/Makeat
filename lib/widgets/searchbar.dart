// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sqflite/sqflite.dart';
import "../widgets/fonts.dart";

getMatchedRecipesId(String query){
  final sqliteDB = openDatabase("assets/sqlite/makeatDB.db");
}

Widget buildFloatingSearchBar() {
  // final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  return FloatingSearchBar(
    elevation: 10.0,
    borderRadius: BorderRadius.circular(10),
    margins: EdgeInsets.fromLTRB(20, 28, 20, 10),
    automaticallyImplyBackButton: false,
    closeOnBackdropTap: true,
    hint: 'Search Recipe...',
    hintStyle: mfont15,
    queryStyle: mfont15,
    iconColor: Color(0xff3BB143),
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 500),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    // axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    // width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      getMatchedRecipesId(query);
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: Icon(CupertinoIcons.search),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 100, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}
