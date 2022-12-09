import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy_do/View/chatroomscreen.dart';
import 'package:howdy_do/View/conversation_screen.dart';
import 'package:howdy_do/helper/constants.dart';
import 'package:howdy_do/helper/helperfunctions.dart';
import 'package:howdy_do/services/database.dart';
import 'package:howdy_do/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}



class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new  TextEditingController();

  QuerySnapshot searchResultSnapshot;



  Widget searchList(){
    return searchResultSnapshot != null ?  ListView.builder(
        itemCount: searchResultSnapshot.docs.length ,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return  SearchTile(
            userName: searchResultSnapshot.docs[index].data()["name"],
              userEmail: searchResultSnapshot.docs[index].data()["email"],

          );
        }) : Container();
  }


  initiateSearch(){
    DatabaseMethods().getUserByUsername(searchTextEditingController.text)
        .then((val){
      setState(() {
        searchResultSnapshot =  val;
        print("$searchResultSnapshot");
      });
    });}



  Widget SearchTile(  {String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle(),),
              Text(userEmail, style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap:() {
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child:  Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Message", style: mediumTextStyle(),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                      colors:[
                        const Color(0xffF7A1A0),
                        const Color(0xffF8A3A2)
                      ]

                  ),
                )
            ),
          )
        ],

      ),
    );
  }


  createChatroomAndStartConversation({ String userName}){
    print("${Constants.myName}");
    if(userName != Constants.myName) {
      List<String> users = [userName,Constants.myName];
      String chatRoomId =  getChatRoomId(userName,Constants.myName);

      Map<String,dynamic> chatRoomMap= {
        "users": users,
        "chatRoomId" :   chatRoomId ?? "NA"
      };
 print(chatRoomId);

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
      ));
    }else {
      print("You can't send text to yourself");
    }
  }


  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body:Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child:  TextField(
                        controller: searchTextEditingController,
                        style:  TextStyle(
                          color: const Color(0xffa1a0ba),
                          fontFamily: 'Poppins',
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          border: UnderlineInputBorder(
                              borderRadius:BorderRadius.circular(30.0)),
                          hintText: "search username...",
                          hintStyle: TextStyle(
                            color: Colors.black12,
                            fontFamily: 'Poppins',
                          ),

                        ),
                      )
                  ),
                  GestureDetector(
                      onTap: (){
                    initiateSearch();
                      },
                      child:  Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(8),
                          child:Image.asset("assets/images/search_white.png")
                      ) ),
                ],
              ),
            ),
            searchList()

          ],
        ),
      ) ,
    );
  }
}




getChatRoomId(String a, String b) {

  if(a.substring(0, 1).codeUnitAt(0)> b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}