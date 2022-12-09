import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferencesUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey="USEREMAILKEY";

  // saving data to SharedPreferences

static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
SharedPreferences prefs = await SharedPreferences.getInstance();
return await prefs.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
}


static Future<bool> saveUserNameInSharedPreference(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }
  static Future<bool> saveUserEmailInSharedPreferences(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, userEmail);
  }
 // getting data from SharedPreferences

  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferencesUserEmailKey);
  }

}