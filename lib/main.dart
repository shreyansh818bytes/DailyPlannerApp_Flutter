import 'package:daily_planner_app/global.dart';
import 'package:daily_planner_app/screens/choose_calendars_screen.dart';
import 'package:daily_planner_app/screens/sign_in_screen.dart';
import 'package:daily_planner_app/screens/task_list_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      theme: ThemeData(
          primaryColor: Colors.black,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(top: 15, left: 20, bottom: 15, right: 20)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ))),
          )),
      routes: <String, WidgetBuilder>{
        '/': (_) => new SigninHandlerScreen(),
        '/choose_calendar': (_) => new ChooseCalendarsScreen(),
        '/home': (_) => new TaskListScreen(),
      },
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
