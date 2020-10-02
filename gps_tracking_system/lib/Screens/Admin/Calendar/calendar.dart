import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/scrolling_years_calendar.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:gps_tracking_system/Screens/Admin/Setting/settings.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  List<DateTime> getHighlightedDates() {
    return List<DateTime>.generate(
      10,
          (int index) => DateTime.now().add(Duration(days: 10 * (index + 1))),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Calendar'),
      ),
      body: Center(
        child: ScrollingYearsCalendar(
          // Required parameters
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 5 * 365)),
          lastDate: DateTime(2030),
          currentDateColor: Colors.blue,

          // Optional parameters
          highlightedDates: getHighlightedDates(),
          highlightedDateColor: Colors.deepOrange,
          monthNames: const <String>[
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ],
          //onMonthTap: (int year, int month) => print('Tapped $month/$year'),
          onMonthTap: (int year, int month) =>
              //navigateToSubPage(context),
            showDatePicker(
              context: context,
              initialDate: DateTime(year,month),
              firstDate: DateTime(2000),
              lastDate: DateTime(2025),
            )
                .then((selectedDate){
                  if(selectedDate!= null){
                    final dateStr = DateFormat.yMMMMd('en_US').format(selectedDate);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage(dateString: dateStr)));
                  }
                }),
          monthTitleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

