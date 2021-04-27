import 'package:flutter/material.dart';
import 'package:todo/screens/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class Organizer',
      theme: ThemeData(
        primaryColor: Color(0xFF444974),
        //primarySwatch: Colors.red,
      ),
      home: TodoListScreen(),
    );
  }
}
