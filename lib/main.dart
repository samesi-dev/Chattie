import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:howdy_do/View/chatroomscreen.dart';
import 'package:howdy_do/helper/authenticate.dart';
import 'package:howdy_do/helper/helperfunctions.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState()=> _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool userLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
setState(() {
  userLoggedIn= value;
});
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff7C7899),

        primarySwatch: MaterialColor(
        0xff7C7899,
        <int, Color>{
    50: Color(0xff7C7899),
    100: Color(0xff7C7899),
    200: Color(0xff7C7899),
    300: Color(0xff7C7899),
    400: Color(0xff7C7899),
    500: Color(0xff7C7899),
    600: Color(0xff7C7899),
    700: Color(0xff92829D),
    800: Color(0xff92829D),
    900: Color(0xff92829D)
    },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  userLoggedIn != null ?  userLoggedIn ? ChatRoom() : Authenticate() : Container(child: Center(
    child: Authenticate())
      ),
    );
  }
}







