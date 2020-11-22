import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String myName;
  final String userName;
  final String image_url;

  ConversationScreen(
      {this.chatRoomId, this.myName, this.userName, this.image_url});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String text;
  stt.SpeechToText _speech = stt.SpeechToText();
  TextEditingController messageController = TextEditingController();
  Stream chatMessageStream;
  bool _isListening = false;
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
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
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
        .orderBy("time", descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: <Widget>[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: widget.image_url == null
                        ? NetworkImage('')
                        : NetworkImage(widget.image_url),
                    fit: BoxFit.fill),
              ),
            ),
//            Container(
//              width: 50,
//              height: 50,
//              decoration: BoxDecoration(
//                shape: BoxShape.circle,
//                image: DecorationImage(
//                    image: NetworkImage(image_url), fit: BoxFit.fill),
//              ),
//            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.userName == null ? '' : widget.userName,
              style: GoogleFonts.poppins(
                fontSize: 20,

              ),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: ChatMessageList()),
            Container(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          onPressed: () {
                            print("listen function called");
                            _listen();
                          },
                          icon: new Icon(Icons.mic_outlined),
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

  void _listen() async {
    print("1");

    try {
      if (!_isListening) {
        print("2");

        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );

        if (available) {
          print("3");
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              messageController.text = val.recognizedWords;
              print(text);
            }),
          );
        }
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    } catch (e) {
      print(".................................\n\n\n\n\n\n$e");
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,

      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Bubble(
        color: isSendByMe
            ? Color.fromRGBO(219, 248, 199, 1)
            : Color.fromRGBO(230, 221, 214, 1),
        margin: BubbleEdges.all(3),
        style: BubbleStyle(
            nip: isSendByMe ? (BubbleNip.rightTop) : (BubbleNip.leftTop)),
        child: Text(
          message,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
