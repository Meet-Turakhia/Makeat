// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import "../widgets/bottombar.dart";
import "../widgets/fonts.dart";
import "../pages/recipe.dart";
import 'swipecards.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class Home extends StatefulWidget {
  final String uid;
  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = FirebaseFirestore.instance;
  List<String> cardimg = [
    "assets/food2.jpg",
    "assets/food3.jpg",
    "assets/food4.jpg",
    "assets/food1.jpg",
  ];
  List<String> title = [
    "Paneer Tikka",
    "Farmhouse Pizza",
    "Noodle",
    "Pav Bhaji",
  ];
  List<String> cal = [
    "170.9",
    "1110.7",
    "437.9",
    "895.5",
  ];

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
                      child: Image.asset('assets/makeat_transparent.png'),
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: db.collection("recipes").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              // padding: EdgeInsets.only(top: 80),
                              physics: const BouncingScrollPhysics(),
                              itemCount: cardimg.length,
                              itemBuilder: (context, index) {
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
                                        Text(title[index],
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
                                              Text("${cal[index]} Calories",
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
                                              Text("4H45M Time",
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
                                              Text("4.5 Rating",
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
                                        image: AssetImage(cardimg[index]),
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
                                            cardimg[index], title[index]),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return CircularProgressIndicator();
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )),
                  buildFloatingSearchBar(),
                ],
              ),
            ),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
        ));
  }
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
