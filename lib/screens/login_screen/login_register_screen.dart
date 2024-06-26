import 'package:flutter/material.dart';
import 'package:garbage_locator/screens/login_screen/register_screen.dart';

import 'login_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  static const route = '/login';
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool showLogin = true;

  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(
        onTap: toggle,
      );
    } else {
      return RegisterPage(
        onTap: toggle,
      );
    }
  }
}
