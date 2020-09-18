import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/scrolling_years_calendar.dart';
import 'package:gps_tracking_system/color.dart';

class CalendarPage extends StatelessWidget {

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
          onMonthTap: (int year, int month) => print('Tapped $month/$year'),
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

