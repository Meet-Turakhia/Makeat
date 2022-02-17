// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:makeat_app/widgets/globals.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import "../widgets/fonts.dart";

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final db = FirebaseFirestore.instance;

  List<DocumentSnapshot> recipes = [];
  bool isLoading = false;
  bool hasMore = true;
  bool firstCall = true;
  int documentLimit = 15;
  late DocumentSnapshot lastDocument;
  int idLimit = 15;
  int idOffset = 0;

  Future<List> getMatchedRecipesId(String query) async {
    List matchedRecipesId = [];
    if (idLimit > 100000) {
      return matchedRecipesId;
    }
    final makeatDB = await sqliteDB;
    var matchedRecipes = makeatDB.rawQuery(
        "SELECT * FROM recipes WHERE Name LIKE '%$query%' LIMIT $idLimit OFFSET $idOffset");
    for (var i = 0; i < matchedRecipes.length; i++) {
      matchedRecipesId.add(matchedRecipes[i]["RecipeId"]);
    }
    return matchedRecipesId;
  }

  StreamController<List<DocumentSnapshot>> controller =
      StreamController<List<DocumentSnapshot>>();
  Stream<List<DocumentSnapshot>> get streamController => controller.stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  getRecipes(String query) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var matchedRecipesId = await getMatchedRecipesId(query);
    QuerySnapshot querySnapshot;
    querySnapshot = await db
        .collection("recipes")
        .where("id", whereIn: matchedRecipesId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      setLoading(false);
      return;
    }
    recipes.addAll(querySnapshot.docs);
    controller.sink.add(recipes);
    setLoading(false);
  }

  void setLoading([bool value = false]) => setState(
        () {
          isLoading = value;
        },
      );

  @override
  Widget build(BuildContext context) {
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
        // Call your model, bloc, controller here.
        getRecipes(query);
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
              children: Colors.accents.map(
                (color) {
                  return Container(height: 100, color: color);
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}
