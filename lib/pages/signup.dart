// ignore_for_file: prefer_const_constructors
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:makeat_app/controllers/authentications.dart';
import 'package:makeat_app/widgets/showtoast.dart';
import "login.dart";
import "home.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:form_field_validator/form_field_validator.dart";
import "../widgets/fonts.dart";

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String password;
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: "Required"),
    MinLengthValidator(8, errorText: "Minimum 8 Characters are Required"),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: "Passwords must have at least one special character")
  ]);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo/makeat_transparent.png"),
                width: 160.0,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 28.0),
                child: Text(
                  "Register",
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff3BB143),
                            ),
                          ),
                          label: Text(
                            "Email",
                            style: mfontl,
                          ),
                          hintText: "Enter Your Email",
                          hintStyle: mfontl,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color(0xff3BB143),
                          ),
                        ),
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Required"),
                            EmailValidator(errorText: "Invalid Email Address"),
                          ],
                        ),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: pass,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff3BB143),
                              ),
                            ),
                            label: Text(
                              "Password",
                              style: mfontl,
                            ),
                            hintText: "Enter Your Password",
                            hintStyle: mfontl,
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Color(0xff3BB143),
                            ),
                          ),
                          validator: passwordValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          controller: confirmPass,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff3BB143),
                              ),
                            ),
                            label: Text(
                              "Confirm Password",
                              style: mfontl,
                            ),
                            hintText: "Confirm Your Password",
                            hintStyle: mfontl,
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              color: Color(0xff3BB143),
                            ),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Required";
                            }
                            if (pass.text != val) {
                              return "Passwords do not match";
                            }
                          },
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      ElevatedButton(
                        // passing an additional context parameter to show dialog boxs
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            bool isUserCreated = await signUp(
                              email.trim(),
                              password.trim(),
                            );
                            if (isUserCreated) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LogIn(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else {
                            popupMessage("Validation Failed!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(55),
                          primary: Color(0xff3BB143),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      bool isUserPresent = await googleSignIn();
                      if (isUserPresent) {
                        User? user = FirebaseAuth.instance.currentUser;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Home(uid: user!.uid),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Image(
                      image: AssetImage('assets/icons/googleicon.png'),
                      width: 40,
                    ),
                  ),
                  Text(
                    "Or",
                    style: GoogleFonts.ubuntu(fontSize: 15.0),
                  ),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LogIn(),
                        ),
                      );
                    },
                    child: Image(
                      image: AssetImage('assets/icons/loginicon.png'),
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
