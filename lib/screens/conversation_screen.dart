import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String myName;
  ConversationScreen({this.chatRoomId, this.myName});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  Stream chatMessageStream;

  sendMessage() {
    print(widget.myName);
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": widget.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messageMap)
          .catchError((e) {
        print(e.toString());
      });
      messageController.text = "";
    }
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.docs[index].get('message'),
                  snapshot.data.docs[index].get('sendBy') == widget.myName);
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    chatMessageStream = FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Let\'s Talk'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          onPressed: () {},
                          icon: new Icon(Icons.face),
                          color: Colors.teal,
                        ),
                      ),
                      color: Colors.white,
                    ),

                    // Text input
                    Flexible(
                      child: Container(
                        child: TextField(
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20.0,
                          ),
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                    // Send Message Button
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.teal,
                          ),
                          onPressed: sendMessage,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 50.0,
                decoration: new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(color: Colors.grey, width: 0.5)),
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Bubble(
        color: isSendByMe?Color.fromRGBO(219, 248, 199,1):Color.fromRGBO(230,221,214,1),
        margin: BubbleEdges.all(3) ,
         style: BubbleStyle(
             nip: isSendByMe?(BubbleNip.rightTop):(BubbleNip.leftTop)
         ),
        child: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
