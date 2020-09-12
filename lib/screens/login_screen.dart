import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:telegramclone/helper/helperFunctions.dart';
import 'package:telegramclone/screens/chatRoomScreen.dart';
import 'package:telegramclone/services/auth.dart';
import 'package:telegramclone/services/database.dart';

class LoginScreen extends StatefulWidget {
  final Function toggle;

  LoginScreen(this.toggle);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailLoginController.text);

      databaseMethods.getUserByUserEmail(emailLoginController.text).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserEmailSharedPreference(
          snapshotUserInfo.docs[0].get("name"),

        );

      });
      setState(() {
        isLoading = true;
      });


      authMethods
          .signInWithEmailAndPassword(
              emailLoginController.text, passwordLoginController.text)
          .then((value) {
        if (value != null) {

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("images/background_image.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  'Let\'s talk',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 8.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Login with email',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Theme(
                    data: ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.teal,
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.teal,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailLoginController,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter valid email address";
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'abc@gmail.com',
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextFormField(
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Password must be 6 characters long";
                            },
                            controller: passwordLoginController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: "Password",
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          MaterialButton(
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: Text(
                                "Login",
                              ),
                              splashColor: Colors.lightGreenAccent,
                              onPressed: () {
                                signIn();
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                _divider(),
                MaterialButton(
                  onPressed: () => {},
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/google_icon.png'),
                        width: 60,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Signin with google',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Text(
                      'Don\'t have an account? SignUp ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
