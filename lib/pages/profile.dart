// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/controllers/authentications.dart';
import 'package:makeat_app/pages/home.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/pages/login.dart';
import 'package:makeat_app/pages/saved.dart';
import 'about.dart';
import 'profile_edit.dart';
import 'swipecards.dart';
import '../widgets/profile_widget.dart';
import '../widgets/fonts.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  var userName = FirebaseAuth.instance.currentUser!.displayName;
  String userImage = FirebaseAuth.instance.currentUser!.photoURL.toString();
  bool isUserImageAsset = false;
  var likeCollection = FirebaseFirestore.instance.collection("likes");
  var likeCount = 0;
  var saveCollection = FirebaseFirestore.instance.collection("saves");
  var saveCount = 0;
  var preferenceCollection =
      FirebaseFirestore.instance.collection("preferences");
  var isVeganOnly = false;

  var timeselectedRange = RangeValues(0, 0);
  var calselectedRange = RangeValues(0, 0);
  var sugarselectedRange = RangeValues(0, 0);
  var proteinselectedRange = RangeValues(0, 0);
  var sodiumselectedRange = RangeValues(0, 0);
  var fatselectedRange = RangeValues(0, 0);

  late List<bool> isSelected;

  void setPreferenceData() {
    preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .get()
        .then((value) => {
              if (value.docs.isEmpty)
                {
                  preferenceCollection
                      .doc(widget.uid)
                      .collection("preference")
                      .doc(widget.uid)
                      .set({
                    "isVeganOnly": false,
                    "cookTimeMin": 0.0,
                    "cookTimeMax": 500.0,
                    "caloriesMin": 0.0,
                    "caloriesMax": 10000.0,
                    "sugarMin": 0.0,
                    "sugarMax": 1000.0,
                    "proteinMin": 0.0,
                    "proteinMax": 1000.0,
                    "sodiumMin": 0.0,
                    "sodiumMax": 5000.0,
                    "fatMin": 0.0,
                    "fatMax": 1000.0,
                  }),
                  preferenceCollection
                      .doc(widget.uid)
                      .collection("preference")
                      .doc(widget.uid)
                      .get()
                      .then((value) => {
                            setState(() {
                              isVeganOnly = value.get("isVeganOnly");
                              timeselectedRange = RangeValues(
                                  value.get("cookTimeMin"),
                                  value.get("cookTimeMax"));
                              calselectedRange = RangeValues(
                                  value.get("caloriesMin"),
                                  value.get("caloriesMax"));
                              sugarselectedRange = RangeValues(
                                  value.get("sugarMin"), value.get("sugarMax"));
                              proteinselectedRange = RangeValues(
                                  value.get("proteinMin"),
                                  value.get("proteinMax"));
                              sodiumselectedRange = RangeValues(
                                  value.get("sodiumMin"),
                                  value.get("sodiumMax"));
                              fatselectedRange = RangeValues(
                                  value.get("fatMin"), value.get("fatMax"));
                            })
                          }),
                }
              else
                {
                  preferenceCollection
                      .doc(widget.uid)
                      .collection("preference")
                      .doc(widget.uid)
                      .get()
                      .then((value) => {
                            setState(() {
                              isVeganOnly = value.get("isVeganOnly");
                              timeselectedRange = RangeValues(
                                  value.get("cookTimeMin"),
                                  value.get("cookTimeMax"));
                              calselectedRange = RangeValues(
                                  value.get("caloriesMin"),
                                  value.get("caloriesMax"));
                              sugarselectedRange = RangeValues(
                                  value.get("sugarMin"), value.get("sugarMax"));
                              proteinselectedRange = RangeValues(
                                  value.get("proteinMin"),
                                  value.get("proteinMax"));
                              sodiumselectedRange = RangeValues(
                                  value.get("sodiumMin"),
                                  value.get("sodiumMax"));
                              fatselectedRange = RangeValues(
                                  value.get("fatMin"), value.get("fatMax"));
                            })
                          }),
                }
            });
  }

  void setRefreshData() {
    User? user = FirebaseAuth.instance.currentUser;
    var likeCollection = FirebaseFirestore.instance.collection("likes");
    var saveCollection = FirebaseFirestore.instance.collection("saves");

    if (user!.displayName == null) {
      var setName = user.email!.split("@")[0];
      user.updateDisplayName(setName);
      setState(() {
        userName = setName;
      });
    } else {
      setState(() {
        userName = user.displayName;
      });
    }
    if (user.photoURL == null) {
      setState(() {
        userImage = "assets/icons/default-profile.png";
        isUserImageAsset = true;
      });
    } else {
      setState(() {
        userImage = user.photoURL.toString();
      });
    }
    likeCollection.doc(widget.uid).collection("like").get().then(
          (value) => {
            setState(
              () {
                likeCount = value.size;
              },
            ),
          },
        );
    saveCollection.doc(widget.uid).collection("save").get().then(
          (value) => {
            setState(
              () {
                saveCount = value.size;
              },
            ),
          },
        );
    setPreferenceData();
  }

  Future<void> updateVeganPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({"isVeganOnly": isVeganOnly});
  }

  Future<void> updateTimePreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({
      "cookiTimeMin": timeselectedRange.start,
      "cookTimeMax": timeselectedRange.end
    });
  }

  Future<void> updateCaloriesPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({
      "caloriesMin": calselectedRange.start,
      "caloriesMax": calselectedRange.end
    });
  }

  Future<void> updateSugarPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({
      "sugarMin": sugarselectedRange.start,
      "sugarMax": sugarselectedRange.end
    });
  }

  Future<void> updateProteinPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({
      "proteinMin": proteinselectedRange.start,
      "proteinMax": proteinselectedRange.end
    });
  }

  Future<void> updateSodiumPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update({
      "sodiumMin": sodiumselectedRange.start,
      "sodiumMax": sodiumselectedRange.end
    });
  }

  Future<void> updateFatPreference() async {
    await preferenceCollection
        .doc(widget.uid)
        .collection("preference")
        .doc(widget.uid)
        .update(
            {"fatMin": fatselectedRange.start, "fatMax": fatselectedRange.end});
  }

  @override
  void initState() {
    super.initState();
    isSelected = [true, false, false];
    if (user!.displayName == null) {
      var setName = user!.email!.split("@")[0];
      user!.updateDisplayName(setName);
      setState(() {
        userName = setName;
      });
    }
    if (user!.photoURL == null) {
      setState(() {
        userImage = "assets/icons/default-profile.png";
        isUserImageAsset = true;
      });
    }
    likeCollection.doc(widget.uid).collection("like").get().then(
          (value) => {
            setState(
              () {
                likeCount = value.size;
              },
            ),
          },
        );
    saveCollection.doc(widget.uid).collection("save").get().then(
          (value) => {
            setState(
              () {
                saveCount = value.size;
              },
            ),
          },
        );
    setPreferenceData();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false, // To remove back button from appbar
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(2, 2, 10, 2),
              child: Image.asset('assets/logo/makeat_transparent.png'),
            ),
          ],
          title: Text("Profile",
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),
          elevation: 0.0,
        ),

        body: ListView(physics: BouncingScrollPhysics(), children: [
          ProfileWidget(
            imagePath: userImage,
            isAssetImage: isUserImageAsset,
            isEditImage: false,
            onClicked: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              ).then(
                (value) => {
                  setRefreshData(),
                },
              );
            },
          ),

          const SizedBox(height: 24),
          buildName(user!, userName, userImage),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  //liked
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Likes(uid: user!.uid),
                      ),
                    ).then(
                      (value) => {
                        setRefreshData(),
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white24,
                    // side: BorderSide(color: Color(0xff3BB143)),
                    textStyle: mfont15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    splashFactory: InkSplash.splashFactory,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$likeCount",
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        "Liked",
                        style: GoogleFonts.ubuntu(
                            fontSize: 13.0, color: Colors.black45),
                      ),
                    ],
                  ),
                ),

                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white24,
                //     borderRadius: BorderRadius.circular(20.0),
                //   ),
                //   child: ToggleButtons(
                //     isSelected: isSelected,
                //     color: Colors.black,
                //     selectedColor: Color(0xff3BB143),
                //     selectedBorderColor: Colors.black,
                //     fillColor: Colors.black,
                //     splashColor: Colors.black,
                //     borderColor: Colors.black26,
                //     borderWidth: 0.5,
                //     borderRadius: BorderRadius.circular(20.0),
                //     direction: Axis.vertical,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'All',
                //           style: GoogleFonts.ubuntu(
                //               fontWeight: FontWeight.bold, fontSize: 15),
                //         ),
                //       ),
                //       // second toggle button
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'Veg',
                //           style: GoogleFonts.ubuntu(
                //               fontWeight: FontWeight.bold, fontSize: 15),
                //         ),
                //       ),
                //       // third toggle button
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'Vegan',
                //           style: GoogleFonts.ubuntu(
                //               fontWeight: FontWeight.bold, fontSize: 15),
                //         ),
                //       ),
                //     ],
                //     onPressed: (int index) {
                //       setState(() {
                //         for (int i = 0; i < isSelected.length; i++) {
                //           isSelected[i] = i == index;
                //         }
                //       });
                //     },
                //   ),
                // ),

                Column(
                  children: [
                    Text(
                      "Vegan Only",
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    CupertinoSwitch(
                      // trackColor: Colors.black,
                      activeColor: Color(0xff3BB143),
                      value: isVeganOnly,
                      onChanged: (bool newValue) {
                        setState(() {
                          isVeganOnly = newValue;
                        });
                        updateVeganPreference();
                      },
                    ),
                  ],
                ),

                TextButton(
                  //Saved
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Saved(uid: user!.uid),
                      ),
                    ).then(
                      (value) => {
                        setRefreshData(),
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white24,
                    // side: BorderSide(color: Color(0xff3BB143)),
                    textStyle: mfont15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    splashFactory: InkSplash.splashFactory,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$saveCount",
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        "Saved",
                        style: GoogleFonts.ubuntu(
                            fontSize: 13.0, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Container( //divider
          //   margin: EdgeInsets.only(left: 160, right:160),
          //   height: 5,
          //   decoration: BoxDecoration(
          //     color: Colors.black54,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          // ),

          Container(
            //preferences container
            // padding: EdgeInsets.all(3),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ExpansionTile(
              textColor: Color(0xff3BB143),
              iconColor: Color(0xff3BB143),
              backgroundColor: Colors.white24,
              collapsedIconColor: Colors.black,
              collapsedTextColor: Colors.black,
              collapsedBackgroundColor: Colors.transparent,
              controlAffinity:
                  ListTileControlAffinity.leading, // to activate leading icons
              leading: Icon(CupertinoIcons.slider_horizontal_3),
              childrenPadding: EdgeInsets.all(10),
              title: Text(
                "Preferences",
                style: GoogleFonts.ubuntu(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Calories, Cook Time, etc.",
                style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.black45),
              ),
              trailing: Icon(CupertinoIcons.chevron_up_chevron_down),
              children: <Widget>[
                ListTile(
                  dense: true,
                  title: Text(
                    "Cook Time",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose recipe cook time between 0 to 500 Min",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: timeselectedRange,
                    min: 0,
                    max: 500,
                    divisions: 100,
                    onChanged: (RangeValues timeRange) {
                      setState(() {
                        timeselectedRange = timeRange;
                      });
                      updateTimePreference();
                    },
                    labels: RangeLabels(
                      '${timeselectedRange.start} min',
                      '${timeselectedRange.end} min',
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Calories",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose calories between 0 to 10k",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: calselectedRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    onChanged: (RangeValues calRange) {
                      setState(() {
                        calselectedRange = calRange;
                      });
                      updateCaloriesPreference();
                    },
                    labels: RangeLabels('${calselectedRange.start} cal',
                        '${calselectedRange.end} cal'),
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Sugar",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose sugar between 0 to 1k",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: sugarselectedRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    onChanged: (RangeValues sugarRange) {
                      setState(() {
                        sugarselectedRange = sugarRange;
                      });
                      updateSugarPreference();
                    },
                    labels: RangeLabels(
                      '${sugarselectedRange.start} g',
                      '${sugarselectedRange.end} g',
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Protein",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose protein between 0 to 1k",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: proteinselectedRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    onChanged: (RangeValues proteinRange) {
                      setState(() {
                        proteinselectedRange = proteinRange;
                      });
                      updateProteinPreference();
                    },
                    labels: RangeLabels(
                      '${proteinselectedRange.start} g',
                      '${proteinselectedRange.end} g',
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Sodium",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose sodium between 0 to 5k",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: sodiumselectedRange,
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    onChanged: (RangeValues sodiumRange) {
                      setState(() {
                        sodiumselectedRange = sodiumRange;
                      });
                      updateSodiumPreference();
                    },
                    labels: RangeLabels(
                      '${sodiumselectedRange.start} mg',
                      '${sodiumselectedRange.end} mg',
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Fat",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Choose fat between 0 to 1k",
                    style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    valueIndicatorTextStyle: mfont15,
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                  ),
                  child: RangeSlider(
                    activeColor: Color(0xff3BB143),
                    inactiveColor: Colors.black,
                    values: fatselectedRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    onChanged: (RangeValues fatRange) {
                      setState(() {
                        fatselectedRange = fatRange;
                      });
                      updateFatPreference();
                    },
                    labels: RangeLabels(
                      '${fatselectedRange.start} g',
                      '${fatselectedRange.end} g',
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  subtitle: Text(
                    "Preferences will be saved once window is closed.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),

          buildAbout(context),

          SizedBox(height: 10),
          Text(
            "© 2022 Copyrights by nCoders.",
            style: mfont10,
            textAlign: TextAlign.center,
          ),

          Padding(
            // Logout
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    textStyle: mfont15,
                    backgroundColor: Colors.white,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    splashFactory: InkSplash.splashFactory,
                  ),
                  onPressed: () => {
                    signOutUser().then(
                      (value) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  },
                  icon: Icon(
                    CupertinoIcons.square_arrow_left,
                    color: Color(0xff3BB143),
                    size: 20,
                  ),
                  label: Text("Logout",
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ]),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Tinderswiper(),
              ),
            ).then(
              (value) => {
                setRefreshData(),
              },
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
                    (value) => {
                      setRefreshData(),
                    },
                  );
                },
                icon: Icon(
                  Icons.home_outlined,
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
                  ).then(
                    (value) => {
                      setRefreshData(),
                    },
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
                  ).then(
                    (value) => {
                      setRefreshData(),
                    },
                  );
                },
                icon: Icon(
                  Icons.bookmark_outline,
                  color: Color(0xff3BB143),
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle,
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

Widget buildName(User user, var userName, var userImage) => Column(
      children: [
        Text(
          "$userName",
          style: mfont24b,
        ),
        const SizedBox(height: 4),
        Text(
          "${user.email}",
          style: GoogleFonts.ubuntu(
              color: Colors.black38, fontStyle: FontStyle.italic),
        )
      ],
    );

Widget buildAbout(context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextButton(
        //about
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => About()),
          );
        },
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: Colors.white24,
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          splashFactory: InkSplash.splashFactory,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          // margin: EdgeInsets.fromLTRB(20,20,20,0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo/makeat_transparent.png',
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Makeat from nCoders',
                    style: GoogleFonts.ubuntu(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "About nCoders and App Guide",
                    style:
                        GoogleFonts.ubuntu(fontSize: 12, color: Colors.black45),
                  )
                ],
              ),
              Icon(CupertinoIcons.right_chevron),
            ],
          ),
        ),
      ),
    );
