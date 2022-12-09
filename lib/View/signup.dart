

import 'package:flutter/material.dart';
import 'package:howdy_do/View/chatroomscreen.dart';
import 'package:howdy_do/helper/helperfunctions.dart';
import 'package:howdy_do/services/auth.dart';
import 'package:howdy_do/services/database.dart';
import 'package:howdy_do/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        "name" : usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };
      
      HelperFunctions.saveUserEmailInSharedPreferences(emailTextEditingController.text);
      HelperFunctions.saveUserNameInSharedPreference(usernameTextEditingController.text);
      setState(() {
        isLoading= true;
      });



      authMethod.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
        print("${val.userId}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: isLoading ? Container(
        child: Center ( child:  CircularProgressIndicator(backgroundColor: Colors.white,))
      ): SingleChildScrollView(
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
                    SizedBox(height: 150, width: 120,
                      child: Image.asset('assets/images/chattie.png'),),
                   Form(
                     key: formKey,
                       child: Column(
                      children: [
                        TextFormField(
                          validator: (val){
                            return val.isEmpty ||  val.length < 2 ? "Please provide a valid username": null;
                          },
                          controller: usernameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
                          },
                          controller: emailTextEditingController,
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
                      ],
                    )),
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
                    onTap:(){
                      signMeUp();
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
                      child: Text("Sign Up", style: mediumTextStyle(),),
                    ),
                    ),

                    SizedBox(height:16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: simpleTextStyle(),),
                     GestureDetector(
                              onTap: (){
                               widget.toggle();},
                       child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("SignIn now", style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            decoration: TextDecoration.underline
                        ),)
              ),
              )
                      ],
                    ),
                    SizedBox(height: 50,),
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
