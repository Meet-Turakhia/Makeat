// ignore_for_file: prefer_const_constructors
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:makeat_app/controllers/authentications.dart';
import "login.dart";
import "home.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:form_field_validator/form_field_validator.dart";

var mfont = GoogleFonts.ubuntu(color: Colors.black, fontSize: 15.0);
var mfontw = GoogleFonts.ubuntu(color: Colors.white, fontSize: 15.0);

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String password;
  bool isHidden = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

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
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
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
                          labelText: "Email",
                          hintText: "Enter Your Email",
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
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: isHidden,
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
                            labelText: "Password",
                            hintText: "Enter Your Password",
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Color(0xff3BB143),
                            ),
                            suffixIcon: InkWell(
                              onTap: togglePasswordView,
                              child: Icon(
                                isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xff3BB143),
                              ),
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                            MinLengthValidator(8,
                                errorText: "Minimum 8 Characters are Required"),
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      ElevatedButton(
                        // passing an additional context parameter to show dialog boxs
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            signUp(email, password).whenComplete(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LogIn(),
                                ),
                              );
                            });
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
                    onPressed: () {
                      googleSignIn().whenComplete(
                        () => MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
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
