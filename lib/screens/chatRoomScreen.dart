import 'package:flutter/material.dart';
import 'package:telegramclone/helper/authentication.dart';
import 'package:telegramclone/services/auth.dart';
import 'package:telegramclone/screens/search.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  AuthMethods authMethods=new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.teal,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Let\'s talk',
            style: TextStyle(
              letterSpacing: 3.0,
              fontSize: 25,
              fontWeight: FontWeight.w300
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>AuthenticationState()
                ));

              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0,horizontal:25),
                child: Icon(
                  Icons.exit_to_app
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>SearchScreen()
            ));
          },
        ),
      ),
    );
  }
}
