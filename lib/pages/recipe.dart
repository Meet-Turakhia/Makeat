// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import "../widgets/bottombar.dart";
import "../widgets/fonts.dart";
import 'swipecards.dart';

class Recipe extends StatefulWidget {
  final String img;
  final String title;
  const Recipe(this.img, this.title, {Key? key}) : super(key: key);
  // Recipe(List<String> cardimg, { Key key, this.img }) : super(key: key);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  bool likeisPressed = false;

  _likeispressed() {
    var newVal1 = true;
    if (likeisPressed) {
      newVal1 = false;
    } else {
      newVal1 = true;
    }

    setState(() {
      likeisPressed = newVal1;
    });
  }

  bool saveisPressed = false;

  _saveispressed() {
    var newVal2 = true;
    if (saveisPressed) {
      newVal2 = false;
    } else {
      newVal2 = true;
    }

    setState(() {
      saveisPressed = newVal2;
    });
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
              child: Image.asset('assets/makeat_transparent.png'),
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
          child: Stack(
            children: [
              Image.asset(
                widget.img,
                width: 800,
                height: 300,
                fit: BoxFit.cover,
              ),
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Flexible(
                    child: Container(
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
                                              child: Text(widget.title,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  )))),
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
                                            "Total Cook Time",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "24H45M",
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
                                            "170.9",
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
                                            "Rating",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "4.5",
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
                                            "Frozen Desserts",
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
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
                                      icon: Icon(likeisPressed
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
                                        saveisPressed
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
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
                              'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'
                              'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in'
                              'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
                              ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt'
                              'mollit anim id est laborum'
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
                              'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'
                              'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in'
                              'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
                              ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt'
                              'mollit anim id est laborum',
                              softWrap: true,
                              style: mfont15,
                              textAlign: TextAlign.justify,
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
                                    label: Text("Read out Instructions",
                                        style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ],
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
