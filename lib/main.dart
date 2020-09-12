import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/authentication.dart';
import 'helper/helperFunctions.dart';
import 'screens/chatRoomScreen.dart';
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

  bool userIsLoggedIn=false;

  @override
  void initState() {
   getLoggedInState();
    super.initState();
  }

  getLoggedInState() async
  {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Clone',
      theme: ThemeData(

        primaryColor: Colors.lightBlueAccent,


      ),
      home: AuthenticationState()
    );
  }
}
