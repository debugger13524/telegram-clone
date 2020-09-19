import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegramclone/screens/conversation_screen.dart';
import 'package:telegramclone/screens/drawer_screen.dart';
import 'package:telegramclone/screens/login_screen.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Stream chatRoomStream;
  var myName;

  Widget chatRoomList() {
    return chatRoomStream == null
        ? SizedBox()
        : StreamBuilder(
            stream: chatRoomStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SizedBox();
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var i;
                        for (String name
                            in snapshot.data.documents[index].get('users')) {
                          // print(i);
                          if (name != myName) i = name;
                        }
                        return ChatRoomTile(
                          userName: i,
                        );
                      })
                  : Container();
            },
          );
  }

  Widget appBarTitle = new Text(
    "Lets\'s Talk",
    style: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 3),
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

  currentUserImageUrl() async {
    final uid1 = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid1).get();
    final image_url = documentSnapshot.get('image_url');
    return image_url;
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;

    final uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((docsnap) {
      myName = docsnap.get('userName');
      print(myName);
      setState(() {
        chatRoomStream = FirebaseFirestore.instance
            .collection("ChatRoom")
            .where("users", arrayContains: myName)
            .snapshots();
      });
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
        drawer: DrawerScreen(),
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
          IconButton(
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
          Container(
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignInScreen(),
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal,
            ),
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

class ChatRoomTile extends StatefulWidget {
  final String userName;

  ChatRoomTile({this.userName});

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  QuerySnapshot querySnapshot;
  String userEmail, image_url, myName;
  String chatRoomId;

  @override
  void initState() {
    super.initState();
  }

  getMyName() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    myName = await documentSnapshot.get('userName');
    chatRoomId = getChatRoomId(widget.userName, myName);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          final uid = FirebaseAuth.instance.currentUser.uid;
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          final myName = documentSnapshot.get('userName');
          print(myName);
          print(widget.userName);
          if (widget.userName != myName) {
            String chatRoomId = getChatRoomId(widget.userName, myName);
            List<String> users = [widget.userName, myName];
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
          }
        },
        child: Card(
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              widget.userName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
