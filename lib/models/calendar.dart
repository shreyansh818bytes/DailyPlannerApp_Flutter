import 'dart:convert';

import 'package:googleapis/calendar/v3.dart';

class CalendarModel {
  String id;
  String title;
  String description;
  int colorInt;

  CalendarModel({this.id, this.title, this.description, this.colorInt});

  factory CalendarModel.mapCalendarListEntry(
      CalendarListEntry calendarListEntry) {
    return CalendarModel(
      id: calendarListEntry.id,
      title: calendarListEntry.summary,
      description: calendarListEntry.description,
      colorInt: int.parse(
          "0xff" + calendarListEntry.backgroundColor.replaceAll("#", "")),
    );
  }

  factory CalendarModel.mapString(String encodedCalendarModel) {
    Map<String, dynamic> decodedCalendarModel =
        jsonDecode(encodedCalendarModel);

    return CalendarModel(
      id: decodedCalendarModel["id"],
      title: decodedCalendarModel["title"],
      description: decodedCalendarModel["description"],
      colorInt: decodedCalendarModel["colorInt"],
    );
  }

  @override
  String toString() {
    return jsonEncode({
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'colorInt': this.colorInt,
    });
  }
}
