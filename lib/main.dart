import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telegramclone/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Let\'s Talk',
        theme: ThemeData(
          primaryColor: Colors.green,
          backgroundColor: Colors.teal,
          accentColor: Colors.tealAccent,
          buttonTheme: ButtonTheme.of(context).copyWith(buttonColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),),
        ),
        home: SignInScreen());
  }
}
