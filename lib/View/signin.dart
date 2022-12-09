import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howdy_do/helper/helperfunctions.dart';
import 'package:howdy_do/services/auth.dart';
import 'package:howdy_do/services/database.dart';
import 'package:howdy_do/widgets/widget.dart';

import 'chatroomscreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final formkey = GlobalKey<FormState>();
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
bool isLoading = false;
QuerySnapshot snapshotUserInfo;
  signIn(){
 if(formkey.currentState.validate()){

   HelperFunctions.saveUserEmailInSharedPreferences(emailTextEditingController.text);

   databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
     snapshotUserInfo = val;
     HelperFunctions.saveUserNameInSharedPreference(snapshotUserInfo.docs[0].data()["name "]);
   // print("${snapshotUserInfo.docs[0].data()["name "]}");

   });
   // TODO function to get user details
   setState(() {
     isLoading= true;
   });


   authMethod.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
     if(val!= null){

       HelperFunctions.saveUserLoggedInSharedPreference(true);
       Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (context) => ChatRoom()));
     }
   });

 }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 40,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
               Form(
                 key: formkey,
                 child: Column(children:[
                SizedBox(height: 150, width: 120,
                  child: Image.asset('assets/images/chattie.png'),),
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
                    },
                    controller:emailTextEditingController ,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator:  (val){
                      return val.length < 6 ? "Enter Password 6+ characters" : null;
                    },
                    controller: passwordTextEditingController,
                    style: simpleTextStyle(),
                    decoration:textFieldInputDecoration("password"),
                  ),
               ], ), ),
                    SizedBox(height:8,),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Forgot Password?", style: simpleTextStyle(),),
                      ),
                    ),
                    SizedBox(height:8,),

                    GestureDetector(
                      onTap: (){
                        signIn();
                      },
                      child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:[
                            const Color(0xffF7A1A0),
                            const Color(0xffF8A3A2)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign In", style: mediumTextStyle(),),
                    ),
                    ),
                    SizedBox(height:16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: simpleTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                       child:  Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now", style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          decoration: TextDecoration.underline
                        ),)
                        ),
                    ),
                    SizedBox(height: 50,),
                ],
              ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
