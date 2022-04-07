import 'dart:async';

import 'package:daily_planner_app/models/calendar.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

var uuidGenerator = Uuid();

class GoogleAPIHandler {
  String uuid; // unique instance identifier

  final GoogleSignIn googleSignIn = GoogleSignIn(
    // clientId: <CLIENT_ID_KEY>,
    scopes: [
      CalendarApi.calendarEventsScope,
      CalendarApi.calendarScope,
      CalendarApi.calendarSettingsReadonlyScope,
    ],
  );

  GoogleSignInAccount currentUser;

  auth.AuthClient client;

  // Build custom caching service for this handler
  static final List<GoogleAPIHandler> _cache = [];

  factory GoogleAPIHandler() {
    if (_cache.length == 0) {
      print('Creating new instance');

      var uuid = uuidGenerator.v4(); // genenrate a new random UUID string
      var instance = GoogleAPIHandler._createInstance(uuid);

      _cache.add(instance); // Cache instance
    }

    return _cache[_cache.length - 1];
  }

  GoogleAPIHandler._createInstance(this.uuid);

  Future<List<CalendarModel>> getCalendarList() async {
    final CalendarApi api = CalendarApi(client);

    final CalendarList fetchedCalendarList = await api.calendarList.list();

    List<CalendarModel> calendarList = [];
    for (dynamic item in fetchedCalendarList.items) {
      CalendarModel calendar = CalendarModel.mapCalendarListEntry(item);
      calendarList.add(calendar);
    }

    return calendarList;
  }

  Future<List<TaskModel>> getEventList(CalendarModel calendar) async {
    final CalendarApi api = CalendarApi(client);

    final DateTime now = DateTime.now();
    final Events events = await api.events.list(
      calendar.id,
      singleEvents: true,
      orderBy: "startTime",
      timeMin: DateTime(now.year, now.month, now.day - 1).toUtc(),
      timeMax: DateTime(now.year, now.month, now.day + 1).toUtc(),
    );

    final Colors colors = await api.colors.get();

    List<TaskModel> calendarTaskList = [];
    for (Event event in events.items) {
      if (event.end.dateTime == null) {
        continue;
      }
      int colorInt = (event.colorId != null)
          ? int.parse("0xff" +
              colors.event[event.colorId.toString()].background
                  .replaceAll("#", ""))
          : int.parse(
              "0xff" + colors.event["1"].background.replaceAll("#", ""));
      calendarTaskList.add(TaskModel.fromEventsItem(
          event, colorInt, calendar.title.substring(0, 4)));
    }

    return calendarTaskList;
  }

  // Future<void> signOut() => _googleSignIn.disconnect();
}
