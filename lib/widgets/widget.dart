import 'dart:ui';

import'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset( "assets/images/chattie.png", height: 40, ),
    elevation: 0.0,
    centerTitle: false,
  );
}


InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      )
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
      color: Colors.white,
    fontFamily: 'Poppins',
    fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
  fontSize: 17,
  fontWeight: FontWeight.bold

  );
}