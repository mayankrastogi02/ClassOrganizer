import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          // dataSource: ClassDataSource(getAppointments()
          // )
        ),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> classes = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 10, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  classes.add(
    Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Class Name',
        color: Colors.blue,
        recurrenceRule: 'FREQ=DAILY;COUNT=10'),
  );
  return classes;
}

class ClassDataSource extends CalendarDataSource {
  ClassDataSource(List<Appointment> source) {
    appointments = source;
  }
}
