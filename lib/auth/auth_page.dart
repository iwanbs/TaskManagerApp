import 'package:flutter/material.dart';
import 'package:task_manage/screens/SignIn.dart';
import 'package:task_manage/screens/SignUp.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// SHOW THE LOGIN PAGE
  bool showLogInPage = true;

  /// TOGGLE BETWEEN LOGIN and SIGNUP SCREENS
  void toggleScreen() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LoginScreen(showSignUpScreen: toggleScreen);
    } else {
      return SignUpScreen(showLoginScreen: toggleScreen);
    }
  }
}
