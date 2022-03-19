import 'package:daily_planner_app/components/calendar_item.dart';
import 'package:daily_planner_app/global.dart';
import 'package:daily_planner_app/helper/google_api_handler.dart';
import 'package:daily_planner_app/helper/size_config.dart';
import 'package:daily_planner_app/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCalendarsScreen extends StatefulWidget {
  @override
  State createState() => _ChooseCalendarScreenState();
}

class _ChooseCalendarScreenState extends State<ChooseCalendarsScreen> {
  List<CalendarModel> _calendarList;
  List<bool> _selectedCalendarList = [];
  List<CalendarItem> _calendarItemList = [];
  bool _isContextLoading = true;
  bool _isDoneLoading = false;

  @override
  void initState() {
    super.initState();
    _handleGetCalendarList();
  }

  // Get calendar list from API.
  void _handleGetCalendarList() async {
    final GoogleAPIHandler api = GoogleAPIHandler();
    _calendarList = await api.getCalendarList();
    _generateCalendarItemList();
  }

  void _generateCalendarItemList() {
    for (CalendarModel calendar in _calendarList) {
      _calendarItemList.add(CalendarItem(
        calendar: calendar,
        isSelected: false,
      ));

      _selectedCalendarList.add(false);
    }

    setState(() {
      _isContextLoading = false;
    });
  }

  void _onPressDone() async {
    setState(() {
      _isDoneLoading = true;
    });
    List<String> stringCalendarList = [];

    int index = 0;
    for (bool flag in _selectedCalendarList) {
      if (flag) {
        stringCalendarList.add(_calendarList[index].toString());
      }
      index++;
    }

    // Save selected calendars to shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('calendarList', stringCalendarList);

    // Navigate to home screen.
    navigatorKey.currentState.pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isContextLoading
            ? SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  strokeWidth: 6.0,
                ),
                height: 80.0,
                width: 80.0,
              )
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 0.55 * SizeConfig.screenHeight,
                      child: ScrollSnapList(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        onItemFocus: (value) {},
                        itemSize: 20 + (0.75 * SizeConfig.screenWidth),
                        itemCount: _calendarList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: CalendarItem(
                              calendar: _calendarList[index],
                              isSelected: _selectedCalendarList[index],
                              changeSelected: (bool value) {
                                _selectedCalendarList[index] = value;
                              },
                              key: Key(_calendarList[index].id.toString()),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    (_isDoneLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                              strokeWidth: 6.0,
                            ),
                            height: 80.0,
                            width: 80.0,
                          )
                        : TextButton.icon(
                            onPressed: _onPressDone,
                            label: const Text('DONE',
                                style: TextStyle(
                                  fontFamily: 'Futura',
                                  fontSize: 38,
                                )),
                            icon: Text(
                              String.fromCharCode(Icons.check.codePoint),
                              style: TextStyle(
                                  fontSize: 48.0,
                                  fontFamily: Icons.check.fontFamily,
                                  fontWeight: FontWeight.w700),
                            ),
                          ))
                  ],
                ),
              ),
      ),
    );
  }
}
