import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_preorder_app/Constants/Color.dart';
import 'package:food_preorder_app/Constants/Text.dart';
import 'package:food_preorder_app/Screens/Home/popUpCalendarSelector.dart';
import 'package:food_preorder_app/Screens/Login/LoginScreen.dart';
import 'package:food_preorder_app/UserModel.dart';
import 'package:food_preorder_app/Widgets/Button.dart';
import 'package:food_preorder_app/Widgets/Calendars/StaticClendar.dart';
import 'package:food_preorder_app/Widgets/OrdersWidget.dart';
import 'package:food_preorder_app/Widgets/Popups/DialogeBox.dart';
import 'package:food_preorder_app/Widgets/Popups/SnackBarWidget.dart';
import 'package:food_preorder_app/Widgets/UserlogButton.dart';
import 'package:food_preorder_app/Widgets/bottomwidget.dart';
import 'package:food_preorder_app/bloc/CalendarBloc/bloc/calendar_bloc.dart';
import 'package:food_preorder_app/utils/add_username_password.dart';

int no_of_orders = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    previous_dates = List.from(getPreviousDates(dates));
    dummydates = List.from(dates);
    getFutureDates(dates);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Hero(
            tag: "mainlogo",
            child: Image.asset(
              "assets/Icons/IVA_Logo.png",
              scale: 25,
            ),
          ),
          flexibleSpace: Stack(children: [
            Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child:
                    Image.asset("assets/Page_Assets/appbar_bananna_leaf.png"))
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  Clear_data();
                  cleardatafrompref();
                  addLoggedout();
                  // SnackbarHelper.showSnackbar(context,
                  // title: "Not implemented!!",
                  // message: "Logout function not yet implemented yet ",
                  // icon: Icons.dangerous_outlined,
                  // color: Colors.red);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Loginscreen()),
                      (route) => false);
                  SnackbarHelper.showSnackbar(context,
                      message: "Logged Out and all user data removed!",
                      icon: Icons.check_box,
                      color: Colors.green);
                },
                icon: const Icon(Icons.logout_outlined, color: Kivawhite)),
          ],
        ),
         bottomSheet:  Bottomannam(),
        body: BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarChanged) {
              SnackbarHelper.showSnackbar(context,
                  message: "Changes Successfull",
                  icon: Icons.check,
                  color: Colors.green);
            } else if (state is ShowingDynamicCalendar) {
              ShowSelectorCalendar(context);
            } else if (state is AddingToDatabase) {
              CustomDialog(
                  message: "adding your orders"); // TODO: implement listener
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 19),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello $UserName!", style: Kmaintext),
                  const SizedBox(height: 24),
                  //NumberOfOrders(numberOfOrders: previous_dates.length),
                  NumberOfOrders(numberOfOrders: Orders_completed),
                  const SizedBox(height: 24),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your orders:",
                            style: Ksecondarytext.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        const UserLogButton(),
                      ]),
                  const SizedBox(height: 16),
                  // Replace with an appropriate widget
                  Container(
                    child: BlocBuilder<CalendarBloc, CalendarState>(
                      builder: (context, state) {
                        if (state is CalendarChanged) {
                          print("calendar is being build again");
                          return  StaticCalendar(
                              // highlightedDates: dates,
                              // isInteractive: false,
                              );
                        }
                        if (state is CalendarInitial){
                          return  StaticCalendar(
                            // highlightedDates: dates,
                          );
                        }

                        return  StaticCalendar(
                            //  highlightedDates: dates,
                            // isInteractive: false,
                            );
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                          Navigation: () {
                            // Navigator.pop(context);
                            // ShowSelectorCalendar(context);
                            context
                                .read<CalendarBloc>()
                                .add(ShowDynamicCalendar());
                          },
                          fontSize: 15,
                          textColor: Kivawhite,
                          textStyle: "Poppins",
                          size: const Size(150, 40),
                          customWidget: Text("Order/Modify",
                              style: Ksecondarytext.copyWith(
                               color: Colors.white),textAlign: TextAlign.center,)),
                    ],
                  ),
                
                ],
              ),
            ),
          ),
        ));
  }
}

