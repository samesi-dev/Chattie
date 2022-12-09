import 'package:flutter/material.dart';
import 'package:howdy_do/View/conversation_screen.dart';
import 'package:howdy_do/View/search.dart';

import 'package:howdy_do/helper/authenticate.dart';
import 'package:howdy_do/helper/constants.dart';
import 'package:howdy_do/helper/helperfunctions.dart';
import 'package:howdy_do/services/auth.dart';
import 'package:howdy_do/services/database.dart';
import 'package:howdy_do/widgets/widget.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index ){

            return ChatRoomsTile(
             snapshot.data.docs[index].data()["chatRoomId"]
                  .toString().replaceAll("_" , "") .replaceAll(Constants.myName, ""),
              snapshot.data.docs[index].data()["chatRoomId"],
            );
        }) : Container();
      },
    );
  }
  @override
  void initState() {
   getUserInfo();

    super.initState();
  }

  getUserInfo() async{
    Constants.myName =  await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots){
      setState(() {
        chatRoomsStream = snapshots;
        print(
            "we got the data + ${chatRoomsStream.toString()} this is name  ${Constants.myName}");
      });
    });
   setState(() {
   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
    title: Image.asset( "assets/images/chattie.png", height: 50, ),
    elevation: 0.0,
    centerTitle: false,
        actions: [
          GestureDetector(
            onTap: ( ){
             authMethod.signOut();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()
             ));
            },
           child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.exit_to_app)),
          )
        ],
    ),
      body:  chatRoomList(),
      floatingActionButton:  FloatingActionButton(
        child:
        Icon(Icons.search) ,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
        },
       ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName,@required this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            color:  const Color(0xffF7A1A0),),
              child: Text("${userName.substring(0,1).toUpperCase()}",
              style: mediumTextStyle(),)),
          SizedBox(width: 8,),
          Text(userName, style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,) )
        ],
      ),
    ));
  }
}
 