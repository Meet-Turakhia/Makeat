// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/home.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/pages/saved.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';
import "../widgets/fonts.dart";
import 'swipecards.dart';
import 'package:text_to_speech/text_to_speech.dart';

class Recipe extends StatefulWidget {
  final String uid;
  final String recipeId;
  final bool homePage;
  final bool likesPage;
  final bool savedPage;
  const Recipe({
    Key? key,
    required this.uid,
    required this.recipeId,
    required this.homePage,
    required this.likesPage,
    required this.savedPage,
  }) : super(key: key);
  // Recipe(List<String> cardimg, { Key key, this.img }) : super(key: key);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var likesCollection = FirebaseFirestore.instance.collection("likes");
  var savesCollection = FirebaseFirestore.instance.collection("saves");
  // ignore: prefer_typing_uninitialized_variables
  var isLikedDoc;
  bool isLiked = false;
  // ignore: prefer_typing_uninitialized_variables
  var isSavedDoc;
  bool isSaved = false;
  late TextToSpeech tts;
  int instructionPointer = -1;
  late List recipeInstructionsList;
  bool isChefUp = false;
  var recipeName = "";
  bool isVoiceCommandsInitialised = false;
  bool isChefBusy = false;

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
    isSavedDoc = await savesCollection
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
    tts = TextToSpeech();
    tts.setVolume(1);
    tts.setRate(0.8);
  }

  @override
  void dispose() {
    VoskFlutterPlugin.stop();
    super.dispose();
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

  Future<void> initVoiceCommands() async {
    if (!isVoiceCommandsInitialised) {
      setState(() {
        isVoiceCommandsInitialised = true;
      });
      await tts.speak("initialising voice commands, please wait");
      ByteData modelZip =
          await rootBundle.load('assets/vosk/vosk-model-small-en-us-0.15.zip');
      await VoskFlutterPlugin.initModel(modelZip);
      try {
        await VoskFlutterPlugin.start();
      } catch (e) {
        await VoskFlutterPlugin.initModel(modelZip);
        await VoskFlutterPlugin.start();
      }
      await tts.speak("voice commands initialised");
    } else {
      setState(() {
        isVoiceCommandsInitialised = false;
      });
      isChefUp = false;
      instructionPointer = -1;
      await VoskFlutterPlugin.stop();
      await tts.speak("voice commands turned off");
    }
  }

  void chefAssist(String command) {
    if (isChefBusy) {
      return;
    }
    isChefBusy = true;
    switch (command) {
      case "start":
        {
          if (!isChefUp) {
            instructionPointer = -1;
            var greeting = getGreeting();
            tts.speak(greeting + ", lets make" + recipeName);
            isChefUp = true;
          } else {
            tts.speak("I am right here, let me know if you need something");
          }
        }
        break;
      case "next":
        {
          if (isChefUp) {
            instructionPointer += 1;
            if (instructionPointer < recipeInstructionsList.length) {
              tts.speak(recipeInstructionsList[instructionPointer]);
            } else {
              instructionPointer -= 1;
              tts.speak(
                  "We are done with the recipe, go enjoy your" + recipeName);
            }
          }
        }
        break;
      case "previous":
        {
          if (isChefUp) {
            instructionPointer -= 1;
            if (instructionPointer == -2) {
              instructionPointer += 1;
              tts.speak(
                  "Recipe instructions are not yet initialised, please do that first");
            } else if (instructionPointer < 0) {
              instructionPointer += 1;
              tts.speak("You are already at the first recipe instruction");
            } else {
              tts.speak(recipeInstructionsList[instructionPointer]);
            }
          }
        }
        break;
      case "repeat":
        {
          if (isChefUp) {
            if (instructionPointer == -1) {
              tts.speak(
                  "Initialise recipe instructions first, so that I can repeat them");
            } else {
              tts.speak(recipeInstructionsList[instructionPointer]);
            }
          }
        }
        break;
      case "commands":
        {
          print("Pending");
        }
        break;
      case "exit":
        {
          if (isChefUp) {
            tts.speak(
                "Bye and have a good day, use start command if you need me again");
            isChefUp = false;
          }
        }
        break;
    }
    isChefBusy = false;
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 18) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  void displayCommands() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff3BB143), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              "Chef Voice Commands",
              style: mfontgbl21,
            ),
          ),
          content: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.arrowtriangle_right_circle_fill,
                    color: Color(0xff3BB143),
                    size: 20.0,
                  ),
                  Text(
                    " Start",
                    style: mfontg15,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Text(
                  "Initialises Chef Voice Assistance",
                  style: mfont15,
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Color(0xff3BB143),
                    size: 20.0,
                  ),
                  Text(
                    " Next",
                    style: mfontg15,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Text(
                  "Speaks the first/next instruction",
                  style: mfont15,
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_left_circle_fill,
                    color: Color(0xff3BB143),
                    size: 20.0,
                  ),
                  Text(
                    " Previous",
                    style: mfontg15,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Text(
                  "Speaks the previous instruction",
                  style: mfont15,
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_2_circlepath_circle_fill,
                    color: Color(0xff3BB143),
                    size: 20.0,
                  ),
                  Text(
                    " Repeat",
                    style: mfontg15,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Text(
                  "Repeats the current instruction",
                  style: mfont15,
                ),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.square_arrow_left_fill,
                    color: Color(0xff3BB143),
                    size: 20.0,
                  ),
                  Text(
                    " Exit",
                    style: mfontg15,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "Exits Chef Voice Assistance",
                  style: mfont15,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xff3BB143),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  "Ok",
                  style: mfontw15,
                ),
              ),
            )
          ],
        );
      },
    );
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
                ds!.forEach((key, value) {
                  if (value == "") {
                    ds[key] = "NA";
                  }
                });
                String totalTime;
                String cookTime;
                String prepTime;
                if (ds["TotalTime"] != "NA") {
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
                if (ds["Images"] == "character(0)" || ds["Images"] == "") {
                  recipeImage = Image.asset(
                    "assets/images/generic_image2.jpg",
                    width: 800,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                } else {
                  recipeImage = Image.network(
                    "${ds['Images'][0]}",
                    width: 800,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/generic_image2.jpg",
                        width: 800,
                        height: 300,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }
                List<String> ingredients = [];
                int ingredientsIteration;
                if (ds["RecipeIngredientParts"].runtimeType != List) {
                  ds["RecipeIngredientParts"] =
                      ds["RecipeIngredientParts"].toString().split(" ");
                }
                if (ds["RecipeIngredientQuantities"].runtimeType != List) {
                  ds["RecipeIngredientQuantities"] =
                      ds["RecipeIngredientQuantities"].toString().split(" ");
                }
                List ingredientNames = ds["RecipeIngredientParts"];
                List ingredientQuantities = ds["RecipeIngredientQuantities"];
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
                List instructions = ds["RecipeInstructions"];
                recipeInstructionsList = instructions;
                recipeName = ds["Name"];
                return StreamBuilder<dynamic>(
                  stream: VoskFlutterPlugin.onResult(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var userCommand = snapshot.data
                          .toString()
                          .replaceAll("{", "")
                          .replaceAll("}", "")
                          .replaceAll('"', "")
                          .split(":")[1]
                          .trim();
                      if (userCommand.isNotEmpty) {
                        chefAssist(userCommand);
                      }
                    }
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
                                  colors: const [
                                    Color(0xff3BB143),
                                    Colors.white
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 15,
                                    blurRadius: 50,
                                    offset: Offset(0,
                                        -10), // changes position of card shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                          physics:
                                              const BouncingScrollPhysics(),
                                          children: [
                                            Center(
                                              child: Title(
                                                color: Colors.black,
                                                child: Text(
                                                  "${ds['Name']}",
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
                                                "${ds['AggregatedRating']}",
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
                                                "${ds['RecipeCategory']}",
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
                                                "${ds['Calories']}",
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
                                                "${ds["CarbohydrateContent"]} g",
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
                                                "${ds["CholesterolContent"]} mg",
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
                                                "${ds["FatContent"]} g",
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
                                                "${ds["FiberContent"]} g",
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
                                                "${ds["ProteinContent"]} g",
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
                                                "${ds["SaturatedFatContent"]} g",
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
                                                "${ds["SodiumContent"]} mg",
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
                                                "${ds["SugarContent"]} g",
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
                                                "${ds['RecipeServings']}",
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
                                                ? CupertinoIcons
                                                    .hand_thumbsup_fill
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
                                            splashFactory:
                                                InkSplash.splashFactory,
                                          ),
                                          onPressed: () async {
                                            await initVoiceCommands();
                                            if (isVoiceCommandsInitialised) {
                                              displayCommands();
                                            }
                                          },
                                          onLongPress: () {
                                            displayCommands();
                                          },
                                          icon: isVoiceCommandsInitialised
                                              ? Icon(
                                                  CupertinoIcons
                                                      .pause_circle_fill,
                                                  color: Colors.black,
                                                  size: 40,
                                                )
                                              : Icon(
                                                  CupertinoIcons
                                                      .arrowtriangle_right_circle_fill,
                                                  color: Colors.black,
                                                  size: 40,
                                                ),
                                          label: Text(
                                            "Chef ",
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
                  },
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
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  widget.homePage
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(uid: user!.uid)),
                        );
                },
                icon: Icon(
                  widget.homePage ? Icons.home : Icons.home_outlined,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.likesPage
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Likes(uid: user!.uid)),
                        );
                },
                icon: Icon(
                  widget.likesPage ? Icons.thumb_up : Icons.thumb_up_outlined,
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
                  widget.savedPage
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Saved(uid: user!.uid)),
                        );
                },
                icon: Icon(
                  widget.savedPage ? Icons.bookmark : Icons.bookmark_outline,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
