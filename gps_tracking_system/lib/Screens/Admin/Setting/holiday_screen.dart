import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/Screens/route_generator.dart';
import 'package:gps_tracking_system/Utility/RestApi/common_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/get_holiday_response.dart';
import 'package:gps_tracking_system/Utility/RestApi/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gps_tracking_system/Components/toast_widget';


class HolidayPageScreen extends StatefulWidget {
  @override
  HolidayPageScreenState createState() => HolidayPageScreenState();
}

class HolidayPageScreenState extends State<HolidayPageScreen> {
  CalendarController _calendarController;
  FToast fToast;
  DateTime selectedDate;
  final Set<DateTime> _holidays = Set<DateTime>();

  @override
  Widget build(BuildContext context) {
    return RouteGenerator.buildScaffold(
        Container(
            child: _buildTableCalendar()
        ),
        appbar: AppBar(
          backgroundColor: Color(0xFF65CBF2),
          title: Text("Holiday",
            style: TextStyleFactory.heading5(color: primaryLightColor),),
          elevation: 0,
          iconTheme: IconThemeData(
              color: primaryLightColor
          ),
        ),
    );
  }
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    fToast = FToast();
    fToast.init(context);
    requestHoliday();
  }

  void onDaySelectedCallBack(DateTime day, List events) {
    setState(() {
      selectedDate = DateTime(day.year,day.month,day.day);
      if(_holidays.contains(selectedDate))
        removeHoliday(day);
      else
        addHoliday(day);
    });
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      onDaySelected:onDaySelectedCallBack ,
      initialCalendarFormat: CalendarFormat.month,
      holidays: (){
        Map<DateTime, List>map = {};
        _holidays.forEach((element) {map[element] = [];});
        return map;}(),
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        renderSelectedFirst: false,
        selectedColor: Colors.transparent,
        selectedStyle: TextStyle(color: _holidays.contains(selectedDate)? Colors.red : primaryTextColor ),
        todayColor: Colors.transparent,
        todayStyle: TextStyle( color: _holidays.contains(today())? Colors.red : primaryColor),
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
        weekendStyle: TextStyle(color: Colors.black),
        outsideWeekendStyle: TextStyle(color:Colors.black),
        outsideHolidayStyle: TextStyle(color: Colors.red),
        holidayStyle: TextStyle(color: Colors.red)
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      )
    );
  }

  DateTime today(){
    DateTime today = DateTime.now();
    return DateTime(today.year,today.month, today.day);
  }

  void requestHoliday()async{
    GetHolidayResponse result=await RestApi.admin.getHoliday();
    if (result.response.status == 1) {
      setState(() {
          List<Holiday> _holidaysDate = result.holiday;
          _holidaysDate.forEach((element) {
            List<String> dateStr = element.date.split("-");
            _holidays.add(DateTime(int.parse(dateStr[0]),int.parse(dateStr[1]),int.parse(dateStr[2])));
          });
      });
    } else {
      fToast.showToast(
        toastDuration: Duration(milliseconds: 500),
          child: ToastWidget(
            status: result.response.status,
            msg: result.response.msg,
          ));
    }
  }

  void addHoliday(DateTime day)async{
    DateTime date=DateTime(day.year,day.month,day.day);

    setState(() {
      _holidays.add(date);
    });

    CommonResponse result = await RestApi.admin.addHoliday(date);
    fToast.showToast(
        toastDuration: Duration(milliseconds: 500),
        child: ToastWidget(
          status: result.response.status,
          msg: result.response.msg,
        ));
  }

  void removeHoliday(DateTime day)async{
    DateTime date = DateTime(day.year,day.month,day.day);

    setState(() {
      _holidays.remove(date);
    });

    CommonResponse result = await RestApi.admin.removeHoliday(date);

    fToast.showToast(
        toastDuration: Duration(milliseconds: 500),
        child: ToastWidget(
          status: result.response.status,
          msg: result.response.msg,
        ));

  }

}