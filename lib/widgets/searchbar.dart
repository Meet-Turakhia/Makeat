// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/recipe.dart';
import 'package:makeat_app/widgets/globals.dart';
import 'package:makeat_app/widgets/showtoast.dart';
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
  int documentLimit = 10;
  late DocumentSnapshot lastDocument;
  int idLimit = 10;
  int idOffset = 0;
  var query = "";
  bool allFetched = false;

  ScrollController scrollController = ScrollController();
  StreamController<List<DocumentSnapshot>> controller =
      StreamController<List<DocumentSnapshot>>();
  Stream<List<DocumentSnapshot>> get streamController => controller.stream;

  @override
  void initState() {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getRecipes();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<List> getMatchedRecipesId() async {
    List matchedRecipesId = [];
    if (idOffset > 99990) {
      return matchedRecipesId;
    }
    if (query.isEmpty) {
      controller.sink.add(recipes);
      return matchedRecipesId;
    }
    final makeatDB = await sqliteDB;
    var matchedRecipes = await makeatDB.rawQuery(
        'SELECT * FROM recipes WHERE Name LIKE "%$query%" LIMIT $idLimit OFFSET $idOffset');
    for (var i = 0; i < matchedRecipes.length; i++) {
      matchedRecipesId.add(matchedRecipes[i]["RecipeId"]);
    }
    if (matchedRecipesId.isEmpty && idOffset == 0) {
      controller.sink.add(recipes);
    }
    idOffset += 10;
    return matchedRecipesId;
  }

  getRecipes() async {
    if (isLoading || allFetched) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var matchedRecipesId = await getMatchedRecipesId();
    if (matchedRecipesId.isEmpty) {
      allFetched = true;
      setState(() {
        isLoading = false;
      });
      return;
    }
    QuerySnapshot querySnapshot;
    querySnapshot = await db
        .collection("recipes")
        .where("RecipeId", whereIn: matchedRecipesId)
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
      scrollController: scrollController,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10),
      margins: EdgeInsets.fromLTRB(20, 28, 20, 10),
      automaticallyImplyBackButton: false,
      closeOnBackdropTap: true,
      hint: 'Search Recipe...',
      hintStyle: mfont15,
      queryStyle: mfont15,
      iconColor: Color(0xff3BB143),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 66),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      // axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      // width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (userQuery) {
        // Call your model, bloc, controller here.
        setState(() {
          recipes = [];
          query = userQuery;
          idOffset = 0;
          allFetched = false;
        });
        getRecipes();
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
            elevation: 10.0,
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: streamController,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index < snapshot.data!.length) {
                        DocumentSnapshot docSnap = snapshot.data![index];
                        Map ds = docSnap.data() as Map;
                        ds.forEach((key, value) {
                          if (value == "") {
                            ds[key] = "NA";
                          }
                        });
                        String time = ds["TotalTime"].split("PT")[1];
                        bool isNetworkImage;
                        if (ds["Images"] == "character(0)" ||
                            ds["Images"] == "") {
                          isNetworkImage = false;
                        } else {
                          isNetworkImage = true;
                        }
                        return CupertinoButton(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: isNetworkImage
                                        ? Image.network(
                                            "${ds['Images'][0]}",
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/generic_image2.jpg",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/images/generic_image2.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  height: 80,
                                  width: 100,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${ds['Name']}",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${ds['Calories']} Calories",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                textStyle: TextStyle(
                                                    background:
                                                        Paint() //text black bg
                                                          ..strokeWidth = 14.0
                                                          ..color =
                                                              Colors.black54
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeJoin =
                                                              StrokeJoin.round),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "$time Time",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                textStyle: TextStyle(
                                                    background:
                                                        Paint() //text black bg
                                                          ..strokeWidth = 14.0
                                                          ..color =
                                                              Colors.black54
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeJoin =
                                                              StrokeJoin.round),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${ds['AggregatedRating']} Rating",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                textStyle: TextStyle(
                                                    background:
                                                        Paint() //text black bg
                                                          ..strokeWidth = 14.0
                                                          ..color =
                                                              Color(0xff3BB143)
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeJoin =
                                                              StrokeJoin.round),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onPressed: () {
                            User? user = FirebaseAuth.instance.currentUser;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Recipe(
                                  uid: user!.uid,
                                  recipeId: docSnap.id,
                                  homePage: true,
                                  likesPage: false,
                                  savedPage: false,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 60.0,
                            top: 32.0,
                          ),
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xff3BB143),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "That's All Folks!",
                                    style: mfont15,
                                  ),
                                ),
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  popupMessage("Some Error Occured, Retrying!");
                  return SizedBox(
                    height: 95,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff3BB143),
                      ),
                    ),
                  );
                } else if (!isLoading && query.isNotEmpty) {
                  return SizedBox(
                    height: 95,
                    child: Center(
                      child: Text(
                        "No Matching Recipes Found!",
                        style: mfont15,
                      ),
                    ),
                  );
                } else if (isLoading && query.isNotEmpty) {
                  return SizedBox(
                    height: 95,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff3BB143),
                      ),
                    ),
                  );
                } else {
                  return Center();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
