// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/profile_widget.dart';
import '../widgets/user.dart';
import '../widgets/fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = UserPreferences.mUser;

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
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: "assets/icons/default-profile.png",
              isAssetImage: true,
              // imagePath: isImg ? imageFile.toString() : user.imagePath,
              isEdit: true,
              onClicked: () async {
                // _getFromGallery();
              },
            ),
            Text("Change profile picture here.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontSize: 12, color: Colors.grey, height: 2)),
            const SizedBox(height: 24),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: GoogleFonts.ubuntu(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    style: mfont15,
                    controller: TextEditingController(text: user.email),
                    decoration: InputDecoration(
                      labelText:
                          "email cannot be edited once account is created.",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff3BB143),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (email) {},
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "User Name",
                    style: GoogleFonts.ubuntu(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: TextEditingController(text: user.name),
                    style: mfont15,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hoverColor: Colors.black,
                      labelText: "change your name here.",
                      labelStyle: GoogleFonts.ubuntu(color: Colors.black38),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff3BB143),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (name) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: () => {},
                          icon: Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: Color(0xff3BB143),
                            size: 20,
                          ),
                          label: Text("Save",
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
