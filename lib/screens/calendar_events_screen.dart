import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:todo/helpers/database_helper.dart';
import 'package:todo/models/task_model.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();

  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');

  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = {};
  List<Task> _data = [];

  List<dynamic> _selectedEvents = [];
  List<Widget> get _eventWidgets =>
      _selectedEvents.map((e) => events(e)).toList();

  @override
  void initState() {
    super.initState();
    _updateTaskList();
    _calendarController = CalendarController();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  void _onDaySelected(DateTime day, List taskList) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = _taskList as List;
    });
  }

  Widget calendar() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            gradient:
                LinearGradient(colors: [Colors.red[600], Colors.red[400]]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: new Offset(0.0, 5))
            ]),
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            canEventMarkersOverflow: true,
            markersColor: Colors.white,
            weekdayStyle: TextStyle(color: Colors.white),
            todayColor: Colors.white54,
            todayStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold),
            selectedColor: Colors.red[900],
            outsideWeekendStyle: TextStyle(color: Colors.white60),
            outsideStyle: TextStyle(color: Colors.white60),
            weekendStyle: TextStyle(color: Colors.white),
            renderDaysOfWeek: false,
          ),
          onDaySelected: _onDaySelected,
          calendarController: _calendarController,
          events: _events,
          headerStyle: HeaderStyle(
            leftChevronIcon:
                Icon(Icons.arrow_back_ios, size: 15, color: Colors.white),
            rightChevronIcon:
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white),
            /*
            titleTextStyle:
                GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
            formatButtonDecoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: GoogleFonts.montserrat(
                color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                */
          ),
        ));
  }

  Widget eventTitle() {
    if (_selectedEvents.length == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Text("No events",
            style: Theme.of(context).primaryTextTheme.headline1),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      child:
          Text("Events", style: Theme.of(context).primaryTextTheme.headline1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Calendar",
                    style: Theme.of(context).primaryTextTheme.headline1),
              ],
            ),
          ),
          calendar(),
          eventTitle(),
          Column(children: _eventWidgets),
          SizedBox(height: 60)
        ],
      ),
    );
  }
}
