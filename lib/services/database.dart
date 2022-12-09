import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUserEmail(String userEmail) async{
  return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .get();

  }
  getUserByUsername(String username) async{
  return await FirebaseFirestore.instance.collection("users")
      .where("name", isEqualTo: username)
      .get();

}
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
         .add(userMap);
  }
  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }


  createChatRoom(String chatRoomID, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomID).set(chatRoomMap).catchError((e) {
      print(e);
    });

  }


  addConversationMessage( String chatRoomId, messageMap)
  {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print(e);
    });
  }
  getConversationMessage( String chatRoomId) async
  {
   return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats").orderBy("time", descending: false)
        .snapshots();

  }

  getChatRooms(String userName) async{
    return  await FirebaseFirestore.instance.collection("ChatRoom").where("users", arrayContains: userName)
        .snapshots();

  }
}