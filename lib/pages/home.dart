// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/pages/profile.dart';
import 'package:makeat_app/pages/saved.dart';
import 'package:makeat_app/widgets/fonts.dart';
import 'package:makeat_app/widgets/globals.dart';
import 'package:makeat_app/widgets/searchbar.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import "../pages/recipe.dart";
import 'swipecards.dart';
import "package:cloud_firestore/cloud_firestore.dart";

//start of home class
class Home extends StatefulWidget {
  final String uid;
  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  CollectionReference recipeStream =
      FirebaseFirestore.instance.collection("recipes");
  CollectionReference preferenceCollection =
      FirebaseFirestore.instance.collection("preferences");

  List<DocumentSnapshot> recipes = [];
  bool isLoading = false;
  bool hasMore = true;
  bool firstCall = true;
  int documentLimit = 15;
  bool allFetched = false;
  bool isVeganOnly = false;
  var cookTimeMin = 0.0;
  var cookTimeMax = 500.0;
  var caloriesMin = 0.0;
  var caloriesMax = 10000.0;
  var sugarMin = 0.0;
  var sugarMax = 1000.0;
  var proteinMin = 0.0;
  var proteinMax = 1000.0;
  var sodiumMin = 0.0;
  var sodiumMax = 5000.0;
  var fatMin = 0.0;
  var fatMax = 1000.0;
  bool isPreferenceFetched = false;
  var preferredLimit = 15;
  var preferredOffset = 0;

  StreamController<List<DocumentSnapshot>> controller =
      StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get streamController => controller.stream;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<void> fetchPreferences() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .get()
        .then((value) => {
              isVeganOnly = value.get("isVeganOnly"),
              cookTimeMin = value.get("cookTimeMin"),
              cookTimeMax = value.get("cookTimeMax"),
              caloriesMin = value.get("caloriesMin"),
              caloriesMax = value.get("caloriesMax"),
              sugarMin = value.get("sugarMin"),
              sugarMax = value.get("sugarMax"),
              proteinMin = value.get("proteinMin"),
              proteinMax = value.get("proteinMax"),
              sodiumMin = value.get("sodiumMin"),
              sodiumMax = value.get("sodiumMax"),
              fatMin = value.get("fatMin"),
              fatMax = value.get("fatMax")
            });
  }

  Future<List> getPreferredRecipeIds() async {
    final makeatDB = await sqliteDB;
    List preferredRecipesIds = [];
    List preferredRecipesIdsPrev = [];
    var preferredRecipes;

    if (isVeganOnly) {
      preferredRecipes = await makeatDB.rawQuery(
          "SELECT rowid, * FROM recipes WHERE Keywords LIKE '%Vegan%' AND TotalMins BETWEEN $cookTimeMin AND $cookTimeMax AND Calories BETWEEN $caloriesMin and $caloriesMax AND SugarContent BETWEEN $sugarMin AND $sugarMax AND ProteinContent BETWEEN $proteinMin AND $proteinMax AND SodiumContent BETWEEN $sodiumMin AND $sodiumMax AND FatContent BETWEEN $fatMin AND $fatMax LIMIT $preferredLimit OFFSET $preferredOffset");
    } else {
      preferredRecipes = await makeatDB.rawQuery(
          "SELECT rowid, * FROM recipes WHERE TotalMins BETWEEN $cookTimeMin AND $cookTimeMax AND Calories BETWEEN $caloriesMin and $caloriesMax AND SugarContent BETWEEN $sugarMin AND $sugarMax AND ProteinContent BETWEEN $proteinMin AND $proteinMax AND SodiumContent BETWEEN $sodiumMin AND $sodiumMax AND FatContent BETWEEN $fatMin AND $fatMax LIMIT $preferredLimit OFFSET $preferredOffset");
    }

    for (var i = 0; i < preferredRecipes.length; i++) {
      preferredRecipesIds.add(preferredRecipes[i]["RecipeId"]);
    }

    if (preferredRecipesIds == preferredRecipesIdsPrev) {
      return [];
    }

    if (preferredRecipesIds.isEmpty && preferredOffset == 0) {
      controller.sink.add(recipes);
    }

    preferredOffset += 15;
    return preferredRecipesIds;
  }

  getRecipes() async {
    if (!isPreferenceFetched) {
      await fetchPreferences();
      isPreferenceFetched = true;
    }
    if (isLoading || allFetched) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var preferredRecipesIds = await getPreferredRecipeIds();
    if (preferredRecipesIds.isEmpty) {
      allFetched = true;
      setState(() {
        isLoading = false;
      });
      return;
    }
    QuerySnapshot querySnapshot;
    List<DocumentSnapshot> listQSDocs = [];
    if (firstCall == true) {
      for (var id in preferredRecipesIds) {
        querySnapshot = await db
            .collection("recipes")
            .where("RecipeId", isEqualTo: id)
            .get();
        listQSDocs.add(querySnapshot.docs[0]);
      }
      firstCall = false;
      // ignore: unnecessary_null_comparison
    } else {
      setState(() {
        isLoading = true;
      });
      for (var id in preferredRecipesIds) {
        querySnapshot = await db
            .collection("recipes")
            .where("RecipeId", isEqualTo: id)
            .get();
        listQSDocs.add(querySnapshot.docs[0]);
      }
    }
    if (listQSDocs.isEmpty) {
      setLoading(false);
      allFetched = true;
      return;
    }
    recipes.addAll(listQSDocs);
    controller.sink.add(recipes);
    setLoading(false);
  }

  void setLoading([bool value = false]) => setState(() {
        isLoading = value;
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: const [Color(0xff3BB143), Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false, // To remove back button from appbar
        //   actions: [
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(2, 2, 10, 2),
        //       child: Image.asset('assets/makeat_transparent.png'),
        //     ),
        //     // Image.asset('assets/makeat_transparent.png', scale: 15),
        //   ],
        //   title: Text("Makeat", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
        //   // Text("Makeat", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
        //   elevation: 0.0,
        //   // flexibleSpace: Image(
        //   // image: AssetImage('assets/makeat_transparent.png'),
        //   // fit: BoxFit.contain,
        //   // alignment: Alignment.bottomRight,
        //   // width: 70,
        //   // height: 70,
        //   // ),
        // ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading:
                    false, // To remove back button from appbar
                actions: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2, 2, 10, 2),
                    child: Image.asset('assets/logo/makeat_transparent.png'),
                  ),
                  // Image.asset('assets/makeat_transparent.png', scale: 15),
                ],
                title: Text("Makeat",
                    style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500)),
                // Text("Makeat", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
                elevation: 0.0,
                // flexibleSpace: Image(
                // image: AssetImage('assets/makeat_transparent.png'),
                // fit: BoxFit.contain,
                // alignment: Alignment.bottomRight,
                // width: 70,
                // height: 70,
                // ),
              ),
            ];
          },
          body: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                // buildBottomNavigationBar(),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: streamController,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            double maxScroll =
                                notification.metrics.maxScrollExtent;
                            double currentScroll = notification.metrics.pixels;
                            double delta =
                                MediaQuery.of(context).size.height * 0.99;
                            if (maxScroll - currentScroll <= delta) {
                              getRecipes();
                            }
                            return true;
                          },
                          child: ListView.builder(
                            // padding: EdgeInsets.only(top: 80),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length + 1,
                            itemBuilder: (context, index) {
                              if (index < snapshot.data!.length) {
                                DocumentSnapshot docSnap =
                                    snapshot.data![index];
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
                                  child: Container(
                                    height: 250,
                                    width: 400,
                                    margin: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: isNetworkImage
                                              ? Image.network(
                                                  "${ds['Images'][0]}",
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text("${ds['Name']}",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        background:
                                                            Paint() //text black bg
                                                              ..strokeWidth =
                                                                  21.0
                                                              ..color =
                                                                  Colors.black54
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round),
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: <Shadow>[
                                                      //text shadow of card
                                                      Shadow(
                                                        offset: Offset(2, 2.0),
                                                        blurRadius: 30.0,
                                                        color: Colors.black,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(2, 2.0),
                                                        blurRadius: 30.0,
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // color: Colors.red,
                                                height: 35,
                                                child: ListView(
                                                  padding: EdgeInsets.all(10),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  children: [
                                                    Text(
                                                        "${ds['Calories']} Calories",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              background:
                                                                  Paint() //text black bg
                                                                    ..strokeWidth =
                                                                        17.0
                                                                    ..color = Colors
                                                                        .white70
                                                                    ..style =
                                                                        PaintingStyle
                                                                            .stroke
                                                                    ..strokeJoin =
                                                                        StrokeJoin
                                                                            .round),
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          shadows: <Shadow>[
                                                            //text shadow of card
                                                            Shadow(
                                                              offset: Offset(
                                                                  2, 2.0),
                                                              blurRadius: 20.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        )),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                    ),
                                                    Text("$time Time",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                              background:
                                                                  Paint() //text black bg
                                                                    ..strokeWidth =
                                                                        17.0
                                                                    ..color = Colors
                                                                        .white70
                                                                    ..style =
                                                                        PaintingStyle
                                                                            .stroke
                                                                    ..strokeJoin =
                                                                        StrokeJoin
                                                                            .round),
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          shadows: <Shadow>[
                                                            //text shadow of card
                                                            Shadow(
                                                              offset: Offset(
                                                                  2, 2.0),
                                                              blurRadius: 20.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        )),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                    ),
                                                    Text(
                                                      "${ds['AggregatedRating']} Rating",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.ubuntu(
                                                        textStyle: TextStyle(
                                                            background:
                                                                Paint() //text black bg
                                                                  ..strokeWidth =
                                                                      17.0
                                                                  ..color = Colors
                                                                      .white70
                                                                  ..style =
                                                                      PaintingStyle
                                                                          .stroke
                                                                  ..strokeJoin =
                                                                      StrokeJoin
                                                                          .round),
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        shadows: <Shadow>[
                                                          //text shadow of card
                                                          Shadow(
                                                            offset:
                                                                Offset(2, 2.0),
                                                            blurRadius: 20.0,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.center,
                                      //   colors: [Colors.black, Colors.white],
                                      // ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black45,
                                          spreadRadius: 3,
                                          blurRadius: 10,
                                          offset: Offset(3.5,
                                              7), // changes position of card shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Recipe(
                                          uid: widget.uid,
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
                          ),
                        );
                      } else if (snapshot.hasError) {
                        popupMessage("Some Error Occured, Retrying.../");
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff3BB143),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff3BB143),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SearchBar(),
              ],
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Tinderswiper(),
              ),
            );
          },
          tooltip: 'Scan Ingredients',
          child: Icon(
            CupertinoIcons.camera_viewfinder,
            color: Color(0xff3BB143),
            size: 40,
          ),
          splashColor: Colors.white,
        ),
        extendBody: true, //to make navbar notch transparent
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Likes(uid: user!.uid)),
                  );
                },
                icon: Icon(
                  Icons.thumb_up_outlined,
                  color: Color(0xff3BB143),
                  size: 25,
                ),
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
                    MaterialPageRoute(
                        builder: (context) => Saved(uid: user!.uid)),
                  );
                },
                icon: Icon(
                  Icons.bookmark_outline,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(uid: user!.uid)),
                  );
                },
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
            ],
          ),
        ),
        // BottomAppBar(
        //   color: Colors.white,
        //   shape: CircularNotchedRectangle(),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => Home()),
        //           );
        //         },
        //         icon: Icon(CupertinoIcons.home, color: Color(0xff3BB143)),
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(CupertinoIcons.hand_thumbsup_fill, color: Color(0xff3BB143)),
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(CupertinoIcons.camera_viewfinder, color: Colors.transparent), //space holder
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(CupertinoIcons.bookmark_fill, color: Color(0xff3BB143)),
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(CupertinoIcons.profile_circled, color: Color(0xff3BB143)),
        //       ),
        //     ],
        //   ),
        // )
      ),
    );
  }
}
