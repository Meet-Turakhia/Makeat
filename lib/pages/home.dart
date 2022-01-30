// ignore_for_file: prefer_const_constructors
import "package:flutter/material.dart";
import 'package:makeat_app/controllers/authentications.dart';
import "login.dart";

class LoginPage extends StatefulWidget {
  final String uid;
  static const String routeName = "/login";

  const LoginPage({Key? key, required this.uid}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.uid),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                signOutUser().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LogIn()),
                      (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (s) {},
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                labelText: "Username",
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              validator: (s) {},
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password",
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       Constants.pref.setBool("loggedIn", true);
                            //       // formkey.currentState.validate();
                            //       //   Navigator.push(
                            //       //       context,
                            //       //       MaterialPageRoute(
                            //       //           builder: (context) => HomePage()));
                            //       Navigator.pushReplacementNamed(
                            //           context, HomePage.routeName);
                            //     },
                            //     child: Text("Sign In")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
