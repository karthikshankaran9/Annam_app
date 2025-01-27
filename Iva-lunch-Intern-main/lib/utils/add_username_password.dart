import 'package:food_preorder_app/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

addUsername(username) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs!.setString('Username', username);
}

addpassword(password) async {
 
  prefs!.setString('Password', password);
}
addloggedin() async {
  
   prefs!.setString('loggedin', '1');
}
addLoggedout() async{
  await prefs!.remove('loggedin');
}

deleteUsername() async {
 
  await prefs!.remove('Username');
}
deletePassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('Password');
}

void cleardatafrompref(){
  deleteUsername();
  deletePassword();
}
Future<String?> getUsername() async {
   UserName =  prefs!.getString('Username').toString();
  return prefs!.getString('Username').toString();
}

Future<String?> getPassword() async {
  Password =  prefs!.getString('Password').toString();
  return prefs!.getString('Password').toString();
}