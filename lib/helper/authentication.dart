import 'package:flutter/material.dart';
import 'package:telegramclone/screens/login_screen.dart';
import 'package:telegramclone/screens/signup.dart';
class AuthenticationState extends StatefulWidget {
  @override
  _AuthenticationStateState createState() => _AuthenticationStateState();
}

class _AuthenticationStateState extends State<AuthenticationState> {

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }


  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return showSignIn ? LoginScreen(toggleView) : Signup(toggleView);
  }
}
