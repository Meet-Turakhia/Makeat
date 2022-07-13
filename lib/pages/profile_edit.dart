// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeat_app/pages/profile.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import '../widgets/profile_widget.dart';
import '../widgets/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  var userName = FirebaseAuth.instance.currentUser!.displayName;
  var userImage = FirebaseAuth.instance.currentUser!.photoURL;
  String assetOrEditImage = "assets/icons/default-profile.png";
  bool isEditImage = false;
  bool isAssetImage = FirebaseAuth.instance.currentUser!.photoURL == null;

  Future<void> getGalleryImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      setState(() {
        assetOrEditImage = pickedImage.path.toString();
        isEditImage = true;
      });
    }
  }

  Future<void> getCameraImage() async {
    XFile? clickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (clickedImage != null) {
      setState(() {
        assetOrEditImage = clickedImage.path.toString();
        isEditImage = true;
      });
    }
  }

  void imageUploadOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff3BB143), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Image(
                image: AssetImage("assets/icons/default-profile.png"),
                width: 30.0,
              ),
              Center(
                child: Text(
                  "  Image Upload Options",
                  style: mfontgbl17,
                ),
              ),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  getGalleryImage();
                },
                icon: Icon(
                  Icons.photo_library_rounded,
                  color: Color(0xff3BB143),
                  size: 45.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  getCameraImage();
                },
                icon: Icon(
                  Icons.photo_camera_front_rounded,
                  color: Color(0xff3BB143),
                  size: 50.0,
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
                  "Close",
                  style: mfontw15,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> editProfile() async {
    await user!.updateDisplayName(userName);
    if (isEditImage == true) {
      final userImageUploadPath = "userProfileImage/" + user!.uid;
      final userImageUploadFile = File(assetOrEditImage);
      final userImageUploadRef =
          FirebaseStorage.instance.ref().child(userImageUploadPath);
      await userImageUploadRef.putFile(userImageUploadFile);
      String userImageUploadURL = await userImageUploadRef.getDownloadURL();
      await user!.updatePhotoURL(userImageUploadURL);
    }
    popupMessage("Profile Updated!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(uid: user!.uid),
      ),
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
              imagePath: isAssetImage || isEditImage
                  ? assetOrEditImage
                  : user!.photoURL.toString(),
              isAssetImage: isAssetImage,
              // imagePath: isImg ? imageFile.toString() : user.imagePath,
              isEdit: true,
              isEditImage: isEditImage,
              onClicked: () async {
                imageUploadOptions();
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
                    controller: TextEditingController(text: user!.email),
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
                    initialValue: user!.displayName,
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
                    onChanged: (name) {
                      userName = name;
                    },
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
                          onPressed: () => {
                            editProfile(),
                          },
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
