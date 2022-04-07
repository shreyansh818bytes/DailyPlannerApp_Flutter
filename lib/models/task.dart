import 'package:googleapis/calendar/v3.dart';

class TaskModel {
  String id;
  String title;
  String description;
  String categoryName;
  int colorInt;
  DateTime createdAt;
  TaskCreatorModel creator;
  DateTime startTime;
  DateTime endTime;
  DateTime updatedAt;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.categoryName,
    this.colorInt,
    this.createdAt,
    this.creator,
    this.startTime,
    this.endTime,
    this.updatedAt,
  });

  factory TaskModel.fromEventsItem(
      Event eventsItem, int colorInt, String calendarName,
      [DateTime startTime, DateTime endTime]) {
    return TaskModel(
      id: eventsItem.id,
      title: eventsItem.summary,
      description: eventsItem.description,
      categoryName: calendarName,
      colorInt: colorInt,
      createdAt: eventsItem.created,
      creator: TaskCreatorModel.fromAPIResponseMap(eventsItem.creator),
      startTime: startTime ?? eventsItem.start.dateTime,
      endTime: endTime ?? eventsItem.end.dateTime,
      updatedAt: eventsItem.updated,
    );
  }
}

class TaskCreatorModel {
  String id;
  String email;
  String name;

  TaskCreatorModel({this.id, this.email, this.name});

  factory TaskCreatorModel.fromAPIResponseMap(EventCreator eventCreator) {
    return TaskCreatorModel(
      id: eventCreator.id,
      email: eventCreator.email,
      name: eventCreator.displayName,
    );
  }
}

class Interval {
  DateTime start;
  DateTime end;

  Interval({this.start, this.end});

  bool isOverlapping(DateTime taskStartTime, DateTime taskEndTime) =>
      (this.start.isBefore(taskEndTime) ||
          this.start.isAtSameMomentAs(taskEndTime)) &&
      (this.end.isAfter(taskStartTime) ||
          this.end.isAtSameMomentAs(taskStartTime));
}

class TaskIntervalMapping {
  Map<Interval, List<TaskModel>> map = {};

  TaskIntervalMapping({this.map});

  factory TaskIntervalMapping.fromDateTimeList(List<DateTime> dateTimeList) {
    Map<Interval, List<TaskModel>> map = {};

    for (int index = 0; index < dateTimeList.length - 1; index++) {
      map[Interval(start: dateTimeList[index], end: dateTimeList[index + 1])] =
          [];
    }

    return TaskIntervalMapping(map: map);
  }

  void populate(List<TaskModel> taskList) {
    List<Interval> intervalList = this.map.keys.toList();
    for (TaskModel task in taskList) {
      for (Interval interval in intervalList) {
        if (interval.isOverlapping(task.startTime, task.endTime)) {
          print(task);
          this.map[interval].add(task);
        }
      }
    }
  }
}
