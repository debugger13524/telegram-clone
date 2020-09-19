import 'dart:io';
import 'package:telegramclone/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegramclone/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String userName, String userEmail, String userPassword,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: userEmail, password: userPassword);
        try {
          userCredential.user.sendEmailVerification();

          print(userCredential.user.uid.toString());

          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(userCredential.user.uid + '.jpg');

          await ref
              .putFile(
                image,
              )
              .onComplete;

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user.uid)
              .set({
            'userName': userName,
            'userEmail': userEmail,
            'image_url': url,
          });
        } catch (e) {
          print(e.toString());
        }
      }
      if(userCredential.user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchList(),
          ),
        );
      }
      else{
        Scaffold.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Please verify your email and Login'),
            ),);
        setState(() {

          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
          AuthForm(_submitAuthForm, _isLoading),
        ],
      ),
    );
  }
}
