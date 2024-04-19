import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String userIdKey="USERKEY";
  


Future<bool> saveUserId(String getUserId)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(userIdKey, getUserId);
}


Future<String?> getUserId() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userIdKey);
}
}