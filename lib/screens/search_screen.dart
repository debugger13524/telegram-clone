import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegramclone/screens/conversation_screen.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.documents[index].data['chatRoomId'],
                  );
                })
            : Container();
      },
    );
  }

  Widget appBarTitle = new Text(
    "Search Example",
    style: TextStyle(color: Colors.white),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list = [];
  bool _isSearching;
  String _searchText = "";
  List searchresultuserName = List();
  List searchresultuserEmail = List();
  List searchresultimage_url = List();

  _SearchListState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  currentUserName() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final myName = documentSnapshot.get('userName');
    return myName;
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;

    setState(() {
      chatRoomStream = FirebaseFirestore.instance
          .collection("ChatRoom")
          .where("users", arrayContains: currentUserName())
          .snapshots();
    });
  }

  void values(String searchText) async {
    final querySnap =
        await FirebaseFirestore.instance.collection('users').get();
    for (DocumentSnapshot documentSnapshot in querySnap.docs) {
      if (documentSnapshot.get('userName').toString().contains(searchText))
        _list.add(documentSnapshot);
      print(documentSnapshot.get('userName'));
    }
    print(searchText);
    setState(() {
      searchresultuserName.clear();
      searchresultuserEmail.clear();
      searchresultimage_url.clear();
    });

    if (_isSearching != null) {
      print(_list.length);
      print('==========================================================');
      for (int i = 0; i < _list.length; i++) {
        //    print(_list[i]['userName']);
        String data1 = _list[i].get('userName');
        String data2 = _list[i].get('userEmail');
        String data3 = _list[i].get('image_url');

        searchresultuserName.add(data1);
        searchresultuserEmail.add(data2);
        searchresultimage_url.add(data3);
      }
      setState(() {
        _list.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: Stack(
          children: <Widget>[
            chatRoomList(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: (_controller.text.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchresultuserName.length,
                            itemBuilder: (BuildContext context, int index) {
                              String listData1 = searchresultuserName[index];
                              String listData2 = searchresultuserEmail[index];
                              String listData3 = searchresultimage_url[index];
                              return SearchTile(
                                userName: listData1.toString(),
                                userEmail: listData2.toString(),
                                image_url: listData3.toString(),
                              );
                            },
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    cursorColor: Colors.white,
                    controller: _controller,
                    style: new TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white),
                    ),
                    onChanged: values,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Let\'s Talk",
        style: new TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
            letterSpacing: 3),
      );
      _isSearching = false;
      searchresultuserName.clear();
      searchresultuserEmail.clear();
      searchresultimage_url.clear();
      _controller.clear();
    });
  }

//  void searchOperation(String searchText) {
//    searchresult.clear();
//    if (_isSearching != null) {
//      print(_list.length);
//      for (int i = 0; i < _list.length; i++) {
//        print(_list[i].data('userName'));
//        String data = _list[i].data('userName');
//        if (data.toLowerCase().contains(searchText.toLowerCase())) {
//          setState(() {
//            searchresult.add(data);
//          });
//
//        }
//      }
//    }
//  }
}

class SearchTile extends StatelessWidget {
  final String userName, userEmail, image_url;
  SearchTile({this.userName, this.userEmail, this.image_url});

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void createChatRoomAndStartConversation() async {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(userName),
        subtitle: Text(userEmail),
        leading: Image(
          image: NetworkImage(image_url),
          height: 40,
        ),
        trailing: FlatButton(
          onPressed: () async {
            final uid = FirebaseAuth.instance.currentUser.uid;
            DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            final myName = documentSnapshot.get('userName');
            print(myName);
            print(userName);
            if (userName != myName) {
              String chatRoomId = getChatRoomId(userName, myName);
              List<String> users = [userName, myName];
              Map<String, dynamic> chatRoomMap = {
                "users": users,
                "chatRoomId": chatRoomId,
              };

              FirebaseFirestore.instance
                  .collection('ChatRoom')
                  .doc(chatRoomId)
                  .set(chatRoomMap);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    myName: myName,
                  ),
                ),
              );
            } else {
              print("Cannot message yourself");
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Cannot message yourself'),
              ));
            }
          },
          child: Text(
            'Message',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Colors.teal,
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;

  ChatRoomTile({this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Text(userName),
        ],
      ),
    );
  }
}
