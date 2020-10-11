import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends StatefulWidget{

  final Function(DateTime, List) onDaySelectedCallBack;
  final Function(DateTime, DateTime, CalendarFormat) onVisibleDayChangedCallBack;
  final Function(DateTime, DateTime, CalendarController) onCalendarCreatedCallBack;
  final Map<DateTime, List> event;
  final Map<DateTime, List> holiday;


  CustomTableCalendar({
    this.onDaySelectedCallBack,
    this.onVisibleDayChangedCallBack,
    this.onCalendarCreatedCallBack,
    this.event,
    this.holiday
  });

  @override
  State<StatefulWidget> createState() =>CustomTableCalendarState(
    onDaySelectedCallBack: onDaySelectedCallBack,
    onVisibleDayChangedCallBack:  onVisibleDayChangedCallBack,
    onCalendarCreatedCallBack:  onCalendarCreatedCallBack,
    event: event,
    holiday: holiday
  );

}

class CustomTableCalendarState extends State<CustomTableCalendar>{

  final Function(DateTime, List) onDaySelectedCallBack;
  final Function(DateTime, DateTime, CalendarFormat) onVisibleDayChangedCallBack;
  final Function(DateTime, DateTime, CalendarController) onCalendarCreatedCallBack;
  final Map<DateTime, List> event;
  final Map<DateTime, List> holiday;
  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child:TableCalendar(
          initialCalendarFormat: CalendarFormat.week,
          calendarController: calendarController,
          events: event,
          holidays: holiday,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats:{CalendarFormat.week: "Week",CalendarFormat.month: "Month", },
          calendarStyle: CalendarStyle(
          selectedColor: primaryColor,
          todayColor: Colors.blue,
          markersColor: Colors.amber,
          markersMaxAmount: 1,
          markersPositionBottom: 7,
          weekendStyle: TextStyle(color: secondaryTextColor),
          outsideWeekendStyle: TextStyle(color:secondaryTextColor),
          outsideDaysVisible: false,
        ),
        headerVisible: false,
        onDaySelected: onDaySelected,
        onVisibleDaysChanged: onVisibleDayChanged,
        onCalendarCreated: onCalendarCreated,
      )
    );
  }

  void onDaySelected(DateTime day, List events){
   if(onDaySelectedCallBack == null) return;
   onDaySelectedCallBack(day, events);
  }

  void onVisibleDayChanged(DateTime first, DateTime last, CalendarFormat format){
    if(onVisibleDayChangedCallBack == null) return;
    onVisibleDayChangedCallBack(first, last, format);
  }

  void onCalendarCreated(DateTime first, DateTime last, CalendarFormat format){
    if(onCalendarCreatedCallBack == null) return;
    onCalendarCreatedCallBack(first, last, calendarController);
  }


  CustomTableCalendarState({
    this.onDaySelectedCallBack,
    this.onVisibleDayChangedCallBack,
    this.onCalendarCreatedCallBack,
    this.event,
    this.holiday
  });
}