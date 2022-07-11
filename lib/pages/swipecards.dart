// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/home.dart';
import 'package:makeat_app/pages/likes.dart';
import 'package:makeat_app/pages/saved.dart';
import "../widgets/fonts.dart";
import 'profile.dart';
import 'recipe.dart';

class Tinderswiper extends StatefulWidget {
  const Tinderswiper({Key? key}) : super(key: key);

  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> tinderimages = [
    "assets/food3.jpg",
    "assets/food4.jpg",
    "assets/food1.jpg",
    "assets/food2.jpg",
  ];
  List<String> title = [
    "Farmhouse Pizza",
    "Noodle",
    "Pav Bhaji",
    "Paneer Tikka",
  ];
  List<String> cal = [
    "170.9",
    "1110.7",
    "437.9",
    "895.5",
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    CardController controller;
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
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(2, 2, 10, 2),
        //       child: Image.asset('assets/makeat_transparent.png'),
        //     ),
        //     // Image.asset('assets/makeat_transparent.png', scale: 15),
        //   ],
        //   title: Text("Makeat", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),

        //   elevation: 0.0,
        // ),

        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //shape: BoxShape.circle,
                  ),
                  height: MediaQuery.of(context).size.height * 1,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    // decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    // shape: BoxShape.circle,
                    // ),
                    child: TinderSwapCard(
                      swipeUp: false,
                      swipeDown: false,
                      allowVerticalMovement: false,
                      orientation: AmassOrientation.TOP,
                      totalNum: tinderimages.length,
                      stackNum: 3, // number of cards per stack
                      swipeEdge: 2,
                      animDuration: 500,
                      maxWidth: MediaQuery.of(context).size.width * 1,
                      maxHeight: MediaQuery.of(context).size.width * 2,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      minHeight: MediaQuery.of(context).size.width * 0.5,

                      cardBuilder: (context, index) => Card(
                        color: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                    image: AssetImage(tinderimages[index]),
                                    fit: BoxFit.cover),
                                // shape: BoxShape.circle
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: const [
                                      Colors.black87,
                                      Colors.transparent
                                    ],
                                  ),
                                  // shape: BoxShape.circle
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Text(title[index],
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
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.all(8),
                                      child: Center(
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
                                                            ..strokeWidth = 17.0
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
                                                            ..strokeWidth = 17.0
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
                                                            ..strokeWidth = 17.0
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
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                  ],
                                ),
                              ),
                              // Image.asset('${tinderimages[index]}',fit: BoxFit.cover),
                            )),
                        elevation: 10.0,
                      ),

                      cardController: controller = CardController(),
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        // currentIndex = index;
                        if (orientation.toString() ==
                            'CardSwipeOrientation.LEFT') {
                          //Card is LEFT swiping
                        } else if (orientation.toString() ==
                            'CardSwipeOrientation.RIGHT') {
                          //Card is RIGHT swiping
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Recipe(tinderimages[index], title[index]),
                          //   ),
                          // );
                        }
                        // print("$index ${orientation.toString()}");
                      },
                      // swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                      //   /// Get swiping card's alignment
                      //   if (align.x < -3) {
                      //     //Card is LEFT swiping
                      //   } else if (align.x > 3) {
                      //     //Card is RIGHT swiping
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => Recipe(tinderimages[currentIndex]),
                      //       ),
                      //     );
                      //   }
                      // },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("◀ Discard", style: mfont10),
                      ),
                      Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("Open ▶", style: mfont10),
                      )
                    ],
                  ),
                )
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
                  Icons.bookmark_outlined,
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
      ),
    );
  }
}
