import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class Preferences {
  static var KEY_ID = "Id";
  static var KEY_NAME = "Name";
  static var KEY_ROLE = "UserType";
  static var KEY_Email = "Email";
  static var KEY_Contact = "contact";

 // static var KEY_ProductCount = "contact";
 // static var KEY_CountProduct = "count";
  //static var KEY_Count = "count";


  storeDataAtLogin(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_ID, data["data"]["Id"]);
    prefs.setString(KEY_NAME, data['data']['Name']);
    prefs.setString(KEY_ROLE, data['data']['UserType']);
    prefs.setString(KEY_Email, data['data']['Email']);
    prefs.setString(KEY_Contact, data['data']['contact']);
    //prefs.setString(KEY_CountProduct, data["count"]);

    //prefs.setString(KEY_Count, data['count'][0]);
    //print("KEY_NAME"+data["data"]["Name"].toString());
    //print("KEY_Email"+data["data"]["Email"].toString());
   // print("KEY_Contact"+data["data"]["contact"].toString());
    //print("KEY_ID"+data["data"]["Id"].toString());
    //print("KEY_CountProduct"+data["count"].toString());

  }

}
