import 'package:flutter/material.dart';
import 'package:telegramclone/helper/constants.dart';
import 'package:telegramclone/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream chatMessagesList;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesList,
      builder: (context, snapShot) {
        if (snapShot.data == null) return Container();
        return ListView.builder(
          itemCount: snapShot.data.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(snapShot.data.docs[index].get('message'),
                snapShot.data.docs[index].get('sendBy') == Constants.myName);
          },
        );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesList = value;
      });
    });
    super.initState();
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
          child: Stack(
            children: <Widget>[
              chatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 80,
                  color: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'message',
                          ),
                          controller: messageController,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          sendMessage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.send,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
      color: isSendByMe?Colors.lightGreen:Colors.grey,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Text(
        message,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
      ),
    );
  }
}
