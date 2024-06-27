//import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailValid = true;
  final _passwordValid = true;

  bool _isPasswordVisible = false;

  Future<void> _tryRegistration(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final passwordConfirm = _confirmPasswordController.text;
    final bool didPasswordsMatch;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (password == passwordConfirm) {
        didPasswordsMatch = true;
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print("User registration successful! Logging in...");

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        didPasswordsMatch = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch)));
      }

      Navigator.pop(context);
      if (didPasswordsMatch) {
        Navigator.pushReplacementNamed(context, "/");
      }
    } on Exception catch (e) {
      print("User registration failed: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.registrationFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android
          statusBarBrightness: Brightness.light, // For iOS
          systemNavigationBarColor: Theme.of(context).primaryColor),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Column(
              children: [
                //todo: localized text on the plate
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final logoSize = constraints.maxWidth >
                              MediaQuery.of(context).size.width * 0.8
                          ? MediaQuery.of(context).size.width * 0.8
                          : constraints.maxWidth;

                      return Center(
                        child: Image.asset(
                          'assets/images/cutetrashcan.png',
                          height: logoSize,
                          width: logoSize,
                        ),
                      );
                    },
                  ),
                ),
                // welcome back text
                Text(
                  AppLocalizations.of(context)!.registerHere,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: viewportConstraints.maxHeight * 0.05,
                ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //TODO: create reusable textfields
                          //email textfield
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              alignLabelWithHint: true,
                              labelText:
                                  AppLocalizations.of(context)!.emailAddress,
                              labelStyle: const TextStyle(color: Colors.black),
                              errorText: _emailValid
                                  ? null
                                  : "Please provide a valid email address",
                              errorStyle: const TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          //password textfield
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              alignLabelWithHint: true,
                              labelText: AppLocalizations.of(context)!.password,
                              labelStyle: const TextStyle(color: Colors.black),
                              errorText: _passwordValid
                                  ? null
                                  : "The given password is invalid or not strong enough",
                              errorStyle: const TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_isPasswordVisible,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          //confirm password textfield
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              alignLabelWithHint: true,
                              labelText:
                                  AppLocalizations.of(context)!.confirmPassword,
                              labelStyle: const TextStyle(color: Colors.black),
                              errorText: _passwordValid
                                  ? null
                                  : "The given password is invalid or not strong enough",
                              errorStyle: const TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_isPasswordVisible,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.passwordForgot,
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //login button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              _tryRegistration(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.createAccount,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .alreadyHaveAccount,
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 7),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  AppLocalizations.of(context)!.logIn,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            );
          },
        ),
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