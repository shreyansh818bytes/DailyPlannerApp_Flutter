import 'package:daily_planner_app/global.dart';
import 'package:daily_planner_app/helper/google_api_handler.dart';
import 'package:daily_planner_app/models/calendar.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<CalendarModel> _calendarList;
  TaskIntervalMapping _taskIntervalMapping;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCalendarsList();
  }

  void _getCalendarsList() async {
    // Get calendars list from shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> calendarStringList =
        prefs.getStringList('calendarList') ?? [];
    if (calendarStringList.isNotEmpty) {
      _calendarList = calendarStringList
          .map((calendarString) => CalendarModel.mapString(calendarString))
          .toList();

      // Get Calendar Events
      _getCalendarTaskList();
    } else {
      // Handle Empty Calendar List
      final SnackBar snackBar =
          SnackBar(content: Text("Please choose atleast 1 calendar."));
      scaffoldMessengerKey.currentState.showSnackBar(snackBar);
      navigatorKey.currentState.pushReplacementNamed('/choose_calendar');
    }
  }

  void _getCalendarTaskList() async {
    final GoogleAPIHandler apiHandler = GoogleAPIHandler();
    List<TaskModel> _taskList = [];

    List<TaskModel> calendarList;
    for (CalendarModel calendar in _calendarList) {
      calendarList = await apiHandler.getEventList(calendar);
      _taskList += calendarList;
    }

    List<DateTime> dateTimeList = [];
    _taskList.forEach((task) {
      dateTimeList.add(task.startTime);
      dateTimeList.add(task.endTime);
    });
    print(_taskList);
    dateTimeList = dateTimeList.toSet().toList();
    dateTimeList.sort((a, b) => a.compareTo(b));

    _taskIntervalMapping = TaskIntervalMapping.fromDateTimeList(dateTimeList);
    _taskIntervalMapping.populate(_taskList);

    setState(() {
      _isLoading = false; // TODO Add more elaborate loading system
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: _isLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                strokeWidth: 6.0,
              ),
              height: 80.0,
              width: 80.0,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home Screen',
                  style: TextStyle(fontFamily: 'Futura', fontSize: 44),
                )
              ],
            ),
    ));
  }
}
