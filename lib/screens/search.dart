import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telegramclone/helper/constants.dart';
import 'package:telegramclone/services/database.dart';
import 'package:telegramclone/screens/conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool showList = false;

  TextEditingController searchController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  QuerySnapshot searchSnapshot;
  initiateSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((val) {
      print(val.docs[0].get('email'));
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId),
        ),
      );
    } else {
      print("Cannot send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
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
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('message'),
                      ),
                      onTap: () {
                        createChatRoomAndStartConversation(userName: userName);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userEmail: searchSnapshot.docs[0].get('email'),
                userName: searchSnapshot.docs[0].get('name'),
              );
            })
        : Container();
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
                      onPressed: initiateSearch,
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
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
