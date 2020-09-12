import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods
{
  getUserByUsername(String username)async
  {
        return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }
  getUserByUserEmail(String userEmail)async
  {
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: userEmail).get();
  }
  uploadUserInfo(userMap)
  {
    FirebaseFirestore.instance.collection("users").add(userMap).then((value) => print(value.toString())).catchError((e){
      print(e.toString());
    });
  }
  createChatRoom(String chatRoomId,chatRoomMap){
    // ignore: deprecated_member_use
    FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  addConversationMessages(String chatRoomId,messageMap)
  {
    return FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e)=>print(e.toString()));

  }
  getConversationMessages(String chatRoomId)async
  {
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").orderBy("time",descending: false).snapshots();

  }
}