import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';



mixin CacheManager {
  static Function? resetProviderState;

  static late final SharedPreferences prefs;
  

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }



  static String getString(String key) {
    return prefs.getString(key) ?? "";
  }

  static Future setString(String key, String value) async  {
    return prefs.setString(key, value);
  }
  static Future clearbykey(String value) async  {
    return prefs.remove(value);
  }





 static int getInt(String key) {
    return prefs.getInt(key) ?? 0;
  }

  static Future setInt(String key, int value) async  {
    return prefs.setInt(key, value);
  }



  

 

  

  

  

  


 
}


