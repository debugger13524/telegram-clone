import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Clone',
      theme: ThemeData(

        primaryColor: Colors.lightBlueAccent,


      ),
      home: Signup(),
    );
  }
}
