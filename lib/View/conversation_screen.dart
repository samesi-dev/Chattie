

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howdy_do/helper/constants.dart';
import 'package:howdy_do/services/database.dart';
import 'package:howdy_do/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
   final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

 DatabaseMethods databaseMethods = new DatabaseMethods();
 TextEditingController messageController = new TextEditingController();
Stream chatMessageStream;

  Widget ChatMessageList(){
  return StreamBuilder(
     stream:  chatMessageStream,
  builder: (context, snapshot) {
  return snapshot.hasData ? ListView.builder(
    itemCount: snapshot.data.docs.length,
      itemBuilder: (context,index){
      return MessageTile(
           snapshot.data.docs[index].data()["message"],
          snapshot.data.docs[index].data()["sendBy"] == Constants.myName
      );
      }) : Container();
   },
   );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap= {
        "message": messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text = "";

    }
  }

  @override
  void initState() {
 databaseMethods.getConversationMessage(widget.chatRoomId).then((value){
   setState(() {
     chatMessageStream = value;
   });
 });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
      children: [
        ChatMessageList(),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child:  TextField(
                    controller: messageController,
                    style:  TextStyle(
                      color: const Color(0xffa1a0ba),
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      border: UnderlineInputBorder(
                          borderRadius:BorderRadius.circular(30.0)),
                      hintText: "Message",
                      hintStyle: TextStyle(
                        color: Colors.black12,
                        fontFamily: 'Poppins',
                      ),

                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){
                   sendMessage();
                  },
                  child:  Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(8),
                      child:Image.asset("assets/images/send.png")
                  ) ),
            ],
          ),
        ), )

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
      
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 18, right : isSendByMe ? 18: 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(  colors: isSendByMe ? [
            const Color(0xffF7A1A0),
          const Color(0xffF8A3A2)
          ] : [
            const Color(0xfff1f0f5),
            const Color(0xfff1f0f5)
          ]
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) : BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )

        ),
      child: Text(message, style: isSendByMe ? TextStyle( color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 17,
          ) : TextStyle( color: Colors.black,
      fontFamily: 'Poppins',
      fontSize: 17,
      ),
      )
      ),
    );


  }
}
