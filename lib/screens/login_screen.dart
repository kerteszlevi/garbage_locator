//import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static String route = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _emailValid = true;
  var _passwordValid = true;

  Future<void> _tryLogin(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    //final analytics = Provider.of<FirebaseAnalytics>(context, listen: false);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("Logging in...");

      //analytics.logLogin();

      Navigator.pushReplacementNamed(context, "/");
    } on Exception catch (e) {
      print("Login failed: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed, please try again!")));
    }
  }

  Future<void> _tryRegistration(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    //final analytics = Provider.of<FirebaseAnalytics>(context, listen: false);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //analytics.logSignUp(signUpMethod: "email");

      print("User registration successful! Logging in...");

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //analytics.logLogin();

      Navigator.pushReplacementNamed(context, "/");
    } on Exception catch (e) {
      print("User registration/login failed: ${e.toString()}");
      //analytics.logEvent(name: "registration_failed");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed, please try again!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor, //For Android
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //todo: localized text on the plate
                  Image.asset('assets/images/cutetrashcan.png',
                      width: MediaQuery.of(context).size.width * 0.8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      bottom: true,
                      top: false,
                      left: true,
                      right: true,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                labelText: "Email address",
                                labelStyle: TextStyle(color: Colors.black),
                                errorText: _emailValid
                                    ? null
                                    : "Please provide a valid email address",
                                errorStyle: TextStyle(color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                errorText: _passwordValid
                                    ? null
                                    : "The given password is invalid or not strong enough",
                                errorStyle: TextStyle(color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _tryLogin(context);
                                    },
                                    child: Text("Login".toUpperCase()),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _tryRegistration(context);
                                    },
                                    child: Text("Register".toUpperCase()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
