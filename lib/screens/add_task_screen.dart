import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Add Task',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontSize: 10.0),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (input) =>
                      input.trim().isEmpty ? 'Please enter a task title' : null,
                  onSaved: (input) => _title = input,
                  initialValue: _title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
