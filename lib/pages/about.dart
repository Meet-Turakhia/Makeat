// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/fonts.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
            elevation: 0.0,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            physics: BouncingScrollPhysics(),
            children: [
              Image.asset(
                'assets/logo/ncoders_transparent_black.png',
                height: 30,
              ),
              // assets\ncoders_transparent_black.png
              SizedBox(height: 10),
              Text(
                "by",
                style: mfont10,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              Row(
                //profile row
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //parth
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xff007BC8), Colors.transparent],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: AssetImage('assets/icons/default-profile.png'),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                child: InkWell(onTap: () {}),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Parth\nChudasama',
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //meet
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Color(0xffF1592A), Colors.transparent],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: AssetImage('assets/icons/default-profile.png'),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                child: InkWell(onTap: () {}),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Meet\nTurakhia',
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.white24, Colors.transparent],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Team nCoders',
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lorem ipsum dolor sit amet elit sed do, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      style: mfont15,
                      softWrap: true,
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff3BB143),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'App Guide',
                          style: GoogleFonts.ubuntu(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/logo/makeat_transparent.png',
                          height: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
                      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'
                      'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in'
                      'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
                      ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt'
                      'mollit anim id est laborum',
                      style: mfont15,
                      softWrap: true,
                    ),
                  ],
                ),
              ),

              Image.asset(
                'assets/logo/makeat_transparent.png',
                height: 100,
              ),

              SizedBox(height: 10),
              Text(
                "© 2022 Copyrights by nCoders.",
                style: mfont10,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          )),
    );
  }
}
