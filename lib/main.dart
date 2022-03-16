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
      routes: <String, WidgetBuilder>{
        '/': (_) => new SigninHandlerScreen(),
        '/choose': (_) => new ChooseCalendarsScreen(),
        '/home': (_) => new TaskListScreen(),
      },
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
