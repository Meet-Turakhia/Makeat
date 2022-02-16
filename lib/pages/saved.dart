// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/home.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/widgets/fonts.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import "../pages/recipe.dart";
import 'swipecards.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class Saved extends StatefulWidget {
  final String uid;
  const Saved({Key? key, required this.uid}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  CollectionReference recipeStream =
      FirebaseFirestore.instance.collection("recipes");

  List<DocumentSnapshot> recipes = [];
  bool isLoading = false;
  bool isIdLoading = false;
  bool hasMore = true;
  bool firstCall = true;
  bool getSavedRecipesFirstCall = true;
  int documentLimit = 15;
  int getSavedDocumentsLimit = 15;
  late DocumentSnapshot lastDocument;
  late DocumentSnapshot lastSavedRecipeDocument;
  final Widget saveSVG = SvgPicture.asset(
    "assets/svgs/save.svg",
    semanticsLabel: 'Save SVG',
  );
  var savedPageTitle = "Try These Next";

  StreamController<List<DocumentSnapshot>> controller =
      StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get streamController => controller.stream;

  @override
  void initState() {
    super.initState();
    getRecipes(false);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<List> getSavedRecipesIdList() async {
    if (isIdLoading) {
      return ["exit"];
    }
    QuerySnapshot<Map<String, dynamic>> savedRecipeDocuments;
    if (getSavedRecipesFirstCall) {
      setState(() {
        isIdLoading = true;
      });
      savedRecipeDocuments = await db
          .collection("saves")
          .doc(widget.uid)
          .collection("save")
          .orderBy("time", descending: true)
          .limit(getSavedDocumentsLimit)
          .get();
      getSavedRecipesFirstCall = false;
    } else {
      setState(() {
        isIdLoading = true;
      });
      savedRecipeDocuments = await db
          .collection("saves")
          .doc(widget.uid)
          .collection("save")
          .orderBy("time", descending: true)
          .startAfterDocument(lastSavedRecipeDocument)
          .limit(getSavedDocumentsLimit)
          .get();
    }
    if (savedRecipeDocuments.docs.isEmpty) {
      setState(() {
        isIdLoading = false;
      });
      return ["exit"];
    }
    final List<DocumentSnapshot> savedRecipes = savedRecipeDocuments.docs;
    var savedRecipesIdList = [];
    for (var element in savedRecipes) {
      savedRecipesIdList.add(element.id);
    }
    lastSavedRecipeDocument =
        savedRecipeDocuments.docs[savedRecipeDocuments.docs.length - 1];
    setState(() {
      isIdLoading = false;
    });
    return savedRecipesIdList;
  }

  getRecipes(bool refresh) async {
    if (isLoading) {
      return;
    }
    var savedRecipesIdList = await getSavedRecipesIdList();
    DocumentSnapshot documentSnapshot;
    List<DocumentSnapshot> listDS = [];
    if (firstCall == true) {
      for (var id in savedRecipesIdList) {
        documentSnapshot = await db.collection("recipes").doc(id).get();
        listDS.add(documentSnapshot);
      }
      firstCall = false;
      // ignore: unnecessary_null_comparison
    } else if (lastDocument == null) {
      setState(() {
        isLoading = true;
      });
      for (var id in savedRecipesIdList) {
        documentSnapshot = await db.collection("recipes").doc(id).get();
        listDS.add(documentSnapshot);
      }
    } else {
      setState(() {
        isLoading = true;
      });
      for (var id in savedRecipesIdList) {
        documentSnapshot = await db.collection("recipes").doc(id).get();
        listDS.add(documentSnapshot);
      }
    }
    if (listDS.first.data() == null && !refresh) {
      if (!firstCall && !isLoading && recipes.isEmpty) {
        setState(() {
          savedPageTitle = "Save Some Recipes";
        });
      }
      setLoading(false);
      return;
    } else if (listDS.first.data() == null && refresh) {
      setState(() {
        savedPageTitle = "Save Some Recipes";
      });
      recipes = [];
      controller.sink.add(recipes);
      setLoading(false);
      return;
    }
    lastDocument = listDS[listDS.length - 1];
    if (refresh) {
      setState(() {
        savedPageTitle = "Try These Next";
      });
      recipes = [];
      recipes.addAll(listDS);
      controller.sink.add(recipes);
    } else {
      recipes.addAll(listDS);
      controller.sink.add(recipes);
    }
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
                title: Text("Saved",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        savedPageTitle,
                        style: mfontgbl21,
                      ),
                    ),
                  ],
                ),
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
                                MediaQuery.of(context).size.height * 0.20;
                            if (maxScroll - currentScroll <= delta) {
                              getRecipes(false);
                            }
                            return true;
                          },
                          child: ListView.builder(
                            // padding: EdgeInsets.only(top: 80),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length + 1,
                            itemBuilder: (context, index) {
                              if (index < snapshot.data!.length) {
                                DocumentSnapshot ds = snapshot.data![index];
                                String time = ds["TotalTime"].split("PT")[1];
                                ImageProvider recipeImage;
                                if (ds["Images"] == "character(0)") {
                                  recipeImage = AssetImage(
                                      "assets/images/generic_image2.jpg");
                                } else {
                                  recipeImage = NetworkImage(
                                      "${ds['Images'].split('"')[1]}");
                                }
                                return CupertinoButton(
                                  child: Container(
                                    height: 250,
                                    width: 400,
                                    margin: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                    padding:
                                        EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ds["Name"],
                                            style: GoogleFonts.ubuntu(
                                              textStyle: TextStyle(
                                                  background:
                                                      Paint() //text black bg
                                                        ..strokeWidth = 21.0
                                                        ..color = Colors.black54
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeJoin =
                                                            StrokeJoin.round),
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
                                        SizedBox(
                                          // color: Colors.red,
                                          height: 35,
                                          child: ListView(
                                            padding: EdgeInsets.all(10),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            children: [
                                              Text("${ds['Calories']} Calories",
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        background:
                                                            Paint() //text black bg
                                                              ..strokeWidth =
                                                                  17.0
                                                              ..color =
                                                                  Colors.white70
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round),
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: <Shadow>[
                                                      //text shadow of card
                                                      Shadow(
                                                        offset: Offset(2, 2.0),
                                                        blurRadius: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.all(12),
                                              ),
                                              Text("$time Time",
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        background:
                                                            Paint() //text black bg
                                                              ..strokeWidth =
                                                                  17.0
                                                              ..color =
                                                                  Colors.white70
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round),
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: <Shadow>[
                                                      //text shadow of card
                                                      Shadow(
                                                        offset: Offset(2, 2.0),
                                                        blurRadius: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.all(12),
                                              ),
                                              Text(
                                                  "${ds['AggregatedRating']} Rating",
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: TextStyle(
                                                        background:
                                                            Paint() //text black bg
                                                              ..strokeWidth =
                                                                  17.0
                                                              ..color =
                                                                  Colors.white70
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round),
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: <Shadow>[
                                                      //text shadow of card
                                                      Shadow(
                                                        offset: Offset(2, 2.0),
                                                        blurRadius: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.center,
                                      //   colors: [Colors.black, Colors.white],
                                      // ),
                                      image: DecorationImage(
                                        image: recipeImage,
                                        fit: BoxFit.cover,
                                      ),
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
                                          recipeId: ds.id,
                                          homePage: false,
                                          likesPage: false,
                                          savedPage: true,
                                        ),
                                      ),
                                    ).then(
                                      (value) => setState(
                                        () {
                                          getSavedRecipesFirstCall = true;
                                          getRecipes(true);
                                        },
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
                      } else if (!isLoading && !firstCall) {
                        return Container(
                          margin: EdgeInsets.all(70.0),
                          padding: EdgeInsets.only(bottom: 60.0),
                          child: Center(
                            child: saveSVG,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(uid: user!.uid)),
                  ).then(
                    (value) => setState(
                      () {
                        getSavedRecipesFirstCall = true;
                        getRecipes(true);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.home_outlined, color: Color(0xff3BB143)),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Likes(uid: user!.uid)),
                  ).then(
                    (value) => setState(
                      () {
                        getSavedRecipesFirstCall = true;
                        getRecipes(true);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.thumb_up_outlined, color: Color(0xff3BB143)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.camera_viewfinder,
                    color: Colors.transparent), //space holder
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark, color: Color(0xff3BB143)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.account_circle_outlined,
                    color: Color(0xff3BB143)),
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
