import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_preorder_app/Screens/Home/HomePage.dart';
import 'package:food_preorder_app/Screens/Login/LoginScreen.dart';
import 'package:food_preorder_app/UserModel.dart';
import 'package:food_preorder_app/Widgets/Popups/DialogeBox.dart';
import 'package:food_preorder_app/Widgets/Popups/showErrorDialog.dart';
import 'package:food_preorder_app/bloc/AuthBloc/auth_bloc.dart';
import 'package:food_preorder_app/utils/add_username_password.dart';

class Autologger extends StatefulWidget {
  const Autologger({super.key});

  @override
  State<Autologger> createState() => _AutologgerState();
}

class _AutologgerState extends State<Autologger> {
  @override
  void initState() {
    super.initState();
    // Provide the username and password here
     getUsername().toString();
     getPassword().toString();
     print(UserName);
     print(Password);
    //  Future.delayed(Duration(seconds: 3));
    // print("tempusername"+temppassword.toString());
    // print("temp username"+ tempusername);
    context.read<AuthBloc>().add(AuthenticateUser(userName: UserName , password: Password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GettingUserInfo) {
            // Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialog(message: "Getting User info..");
              },
            );
          }
          // if (state is AuthLoading) {
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) {
          //       return CustomDialog(message: "Logging in...");
          //     },
          //   );
          // }
          if (state is AuthSuccessfull) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          }
          if (state is AuthFailed) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)
            => Loginscreen()),(Route<dynamic> route) => false,);
            showErrorDialog(context, state.errorMessage, "Login Error");
          }
        },
        child: Center(child: Image.asset("assets/bottomImage/annamImage.png")),
      ),
    );
  }
}
