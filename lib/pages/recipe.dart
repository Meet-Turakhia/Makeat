// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import "../widgets/bottombar.dart";
import "../widgets/fonts.dart";
import 'swipecards.dart';

class Recipe extends StatefulWidget {
  final String uid;
  final String recipeId;
  const Recipe({Key? key, required this.uid, required this.recipeId})
      : super(key: key);
  // Recipe(List<String> cardimg, { Key key, this.img }) : super(key: key);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final db = FirebaseFirestore.instance;
  var likesCollection = FirebaseFirestore.instance.collection("likes");
  var savesCollection = FirebaseFirestore.instance.collection("saves");
  // ignore: prefer_typing_uninitialized_variables
  var isLikedDoc;
  bool isLiked = false;
  // ignore: prefer_typing_uninitialized_variables
  var isSavedDoc;
  bool isSaved = false;

  void setLike() async {
    isLikedDoc = await likesCollection
        .doc(widget.uid)
        .collection("like")
        .doc(widget.recipeId)
        .get();
    setState(() {
      isLiked = isLikedDoc.exists;
    });
  }

  void setSave() async {
    isSavedDoc = savesCollection
        .doc(widget.uid)
        .collection("save")
        .doc(widget.recipeId)
        .get();
    setState(() {
      isSaved = isSavedDoc.exists;
    });
  }

  @override
  void initState() {
    super.initState();
    setLike();
    setSave();
  }

  _likeispressed() {
    if (isLiked) {
      likesCollection
          .doc(widget.uid)
          .collection("like")
          .doc(widget.recipeId)
          .delete();
    } else {
      likesCollection
          .doc(widget.uid)
          .collection("like")
          .doc(widget.recipeId)
          .set({
        "recipeId": widget.recipeId,
        "time": DateTime.now(),
      });
    }
    setLike();
  }

  _saveispressed() {
    if (isSaved) {
      savesCollection
          .doc(widget.uid)
          .collection("save")
          .doc(widget.recipeId)
          .delete();
    } else {
      savesCollection
          .doc(widget.uid)
          .collection("save")
          .doc(widget.recipeId)
          .set({
        "recipeId": widget.recipeId,
        "time": DateTime.now(),
      });
    }
    setSave();
  }

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xff3BB143)),
          automaticallyImplyLeading: true, // back button appbar
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(2, 2, 10, 2),
              child: Image.asset('assets/logo/makeat_transparent.png'),
            ),
            // Image.asset('assets/makeat_transparent.png', scale: 15),
          ],
          // title: Text("Makeat", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
          shadowColor: Colors.black,
          elevation: 10.0,
          // flexibleSpace: Image(
          // image: AssetImage('assets/makeat_transparent.png'),
          // fit: BoxFit.contain,
          // alignment: Alignment.bottomRight,
          // width: 70,
          // height: 70,
          // ),
        ),
        body: SafeArea(
          bottom: false,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: db.collection("recipes").doc(widget.recipeId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic>? ds = snapshot.data!.data();
                String totalTime;
                String cookTime;
                String prepTime;
                if (ds!["TotalTime"] != "NA") {
                  totalTime = ds["TotalTime"].split("PT")[1];
                } else {
                  totalTime = "NA";
                }
                if (ds["CookTime"] != "NA") {
                  cookTime = ds["CookTime"].split("PT")[1];
                } else {
                  cookTime = "NA";
                }
                if (ds["PrepTime"] != "NA") {
                  prepTime = ds["PrepTime"].split("PT")[1];
                } else {
                  prepTime = "NA";
                }
                Image recipeImage;
                if (ds["Images"] == "character(0)") {
                  recipeImage = Image.asset(
                    "assets/images/generic_image2.jpg",
                    width: 800,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                } else {
                  recipeImage = Image.network(
                    "${ds['Images'].split('"')[1]}",
                    width: 800,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                }
                RegExp doubleQuotesPattern = RegExp('"([^"]*)"|NA');
                List<String> ingredients = [];
                int ingredientsIteration;
                List<String?> ingredientNames = doubleQuotesPattern
                    .allMatches(ds["RecipeIngredientParts"].toString())
                    .map((e) => e.group(0))
                    .toList();
                List<String?> ingredientQuantities = doubleQuotesPattern
                    .allMatches(ds["RecipeIngredientQuantities"].toString())
                    .map((e) => e.group(0))
                    .toList();
                if (ingredientNames.length < ingredientQuantities.length) {
                  ingredientsIteration = ingredientNames.length;
                } else {
                  ingredientsIteration = ingredientQuantities.length;
                }
                for (var i = 0; i < ingredientsIteration; i++) {
                  ingredients.add(
                      "${ingredientQuantities[i]!.replaceAll('"', '').replaceAll('NA', 'some')} ${ingredientNames[i]!.replaceAll('"', '')}");
                }
                for (var i = ingredientsIteration;
                    i < ingredientNames.length;
                    i++) {
                  ingredients
                      .add(ingredientNames[i].toString().replaceAll('"', ''));
                }
                List<String?> instructions = doubleQuotesPattern
                    .allMatches(ds["RecipeInstructions"].toString())
                    .map((e) => e.group(0))
                    .toList();
                return Stack(
                  children: [
                    recipeImage,
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          // height: 600,
                          width: 50,
                          margin: EdgeInsets.fromLTRB(10, 250, 10, 20),
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: const [Color(0xff3BB143), Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 15,
                                blurRadius: 50,
                                offset: Offset(
                                    0, -10), // changes position of card shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.center,
                                    colors: const <Color>[
                                      Colors.transparent,
                                      Colors.red
                                    ],
                                  ).createShader(bounds);
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        Center(
                                          child: Title(
                                            color: Colors.black,
                                            child: Text(
                                              ds["Name"],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Divider(
                                  height: 5,
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                child: Center(
                                  child: ListView(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rating",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["AggregatedRating"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Recipe Category",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["RecipeCategory"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Cook Time",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            totalTime,
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Cook Time",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            cookTime,
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Prep Time",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            prepTime,
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Calories",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["Calories"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Carbohydrate Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["CarbohydrateContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Cholesterol Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["CholesterolContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Fat Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["FatContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Fiber Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["FiberContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Protein Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["ProteinContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Saturated Fat Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["SaturatedFatContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sodium Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["SodiumContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sugar Content",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["SugarContent"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 20,
                                        endIndent: 20,
                                        width: 30,
                                        thickness: 2,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Recipe Servings",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            ds["RecipeServings"],
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xff3BB143),
                                      child: IconButton(
                                        color: Colors.black,
                                        icon: Icon(isLiked
                                            ? CupertinoIcons.hand_thumbsup_fill
                                            : CupertinoIcons.hand_thumbsup),
                                        tooltip: "Like",
                                        onPressed: () {
                                          _likeispressed();
                                        },
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xff3BB143),
                                      child: IconButton(
                                        color: Colors.black,
                                        icon: Icon(
                                          isSaved
                                              ? CupertinoIcons.bookmark_fill
                                              : CupertinoIcons.bookmark,
                                        ),
                                        tooltip: "Save for later",
                                        onPressed: () {
                                          _saveispressed();
                                        },
                                      ),
                                    ),

                                    // IconButton(
                                    //   onPressed: () {
                                    //     _likeispressed();
                                    //   },
                                    //   icon: Icon(likeisPressed ? CupertinoIcons.hand_thumbsup_fill:CupertinoIcons.hand_thumbsup),
                                    //   tooltip: "Like",
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Ingredients",
                                softWrap: true,
                                style: mfontbl,
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${ingredients.join(", ")}.",
                                softWrap: true,
                                style: mfont15,
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Instructions",
                                softWrap: true,
                                style: mfontbl,
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                instructions
                                    .join()
                                    .replaceAll('"', '')
                                    .replaceAll('.', '. '),
                                softWrap: true,
                                style: mfont15,
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        textStyle: mfont15,
                                        backgroundColor: Colors.white24,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        splashFactory: InkSplash.splashFactory,
                                      ),
                                      onPressed: () => {},
                                      icon: Icon(
                                        CupertinoIcons
                                            .arrowtriangle_right_circle_fill,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      label: Text(
                                        "MVA ",
                                        style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
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
        bottomNavigationBar: buildBottomBar(context),
      ),
    );
  }
}
