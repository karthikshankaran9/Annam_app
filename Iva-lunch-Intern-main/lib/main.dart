import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_preorder_app/Screens/Login/Autologger.dart';
import 'package:food_preorder_app/Screens/Login/LoginScreen.dart';
import 'package:food_preorder_app/bloc/AuthBloc/auth_bloc.dart';
import 'package:food_preorder_app/bloc/CalendarBloc/bloc/calendar_bloc.dart';
import 'package:food_preorder_app/bloc/HistoryBloc/history_bloc_bloc.dart';
import 'package:food_preorder_app/bloc/UserLogbloc/user_log_bloc.dart';
import 'package:food_preorder_app/bloc/infoBloc/info_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
bool isloggedin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isloggedin = await checkLoginStatus();
  print(isloggedin);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => CalendarBloc()),
        BlocProvider(create: (context) => UserLogBloc()),
        BlocProvider(create: (context) => HistoryBlocBloc()),
        BlocProvider(create: (context) => InfoBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isloggedin ? Autologger() : Loginscreen(),
      ),
    );
  }
}

Future<bool> checkLoginStatus() async {
  String? loggedin = prefs!.getString('loggedin');
  return loggedin == '1'? true :false;
}
