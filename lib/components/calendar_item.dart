import 'package:daily_planner_app/components/custom_icons_icons.dart';
import 'package:daily_planner_app/helper/size_config.dart';
import 'package:daily_planner_app/models/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  final Key key;
  final CalendarModel calendar;
  final bool isSelected;
  final ValueChanged<bool> changeSelected;

  CalendarItem({this.key, this.calendar, this.isSelected, this.changeSelected});

  State createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isSelected = widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    String calendarTitle = widget.calendar.title;
    calendarTitle = calendarTitle.length > 16
        ? calendarTitle.substring(0, 16) + "..."
        : calendarTitle;

    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.changeSelected(isSelected);
        });
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.75,
        decoration: BoxDecoration(
            color: Color(widget.calendar.colorInt),
            borderRadius: BorderRadius.all(Radius.circular(28))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text(calendarTitle ?? "No title",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Futura',
                            fontSize: 30,
                          )),
                    ),
                    Flexible(
                      flex: 1,
                      child: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 44.0,
                            )
                          : Icon(CustomIcons.circle_thin,
                              color: Colors.white, size: 44.0),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Text(widget.calendar.description ?? "No description.",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FuturaLight',
                      fontSize: 24,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
