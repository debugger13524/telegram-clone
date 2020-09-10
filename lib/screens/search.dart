import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telegramclone/services/database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();

  QuerySnapshot searchSnapshot;
  initializeSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((val) {
      print(val.toString());
      searchSnapshot = val;
    });
  }

  Widget searchList() {
    return ListView.builder(
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (context, index) {
          return SearchTile(
            userEmail: searchSnapshot.docs[index].data['email'],
            userName: searchSnapshot.docs[index].data['name'],
          );
        });
  }

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
              fontWeight: FontWeight.w300,
              fontSize: 25,
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'search username...',
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({this.userEmail, this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('message'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
