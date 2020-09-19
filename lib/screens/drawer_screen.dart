import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegramclone/screens/login_screen.dart';

class DrawerScreen extends StatelessWidget {
  currentUserName() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final myName = documentSnapshot.get('userName');
    return myName;
  }

  currentUserImageUrl() async {
    final uid1 = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid1).get();
    final image_url = documentSnapshot.get('image_url');
    return image_url.toString();
  }

  currentUserEmail() async {
    final uid2 = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid2).get();
    final email = documentSnapshot.get('userEmail');
    return email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        Container(
          height: 325,
          width: 350,
          color: Colors.teal,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: 250,
                height: 250,
                child: FutureBuilder(
                  future: currentUserImageUrl(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(snapshot.data),
                                  fit: BoxFit.fill),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                child: FutureBuilder(
                  future: currentUserName(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            child: Text(
                              snapshot.data,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                child: FutureBuilder(
                  future: currentUserEmail(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            child: Text(
                              snapshot.data,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        : Container();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),

          ],
        ),
      ],
    ));
  }
}
