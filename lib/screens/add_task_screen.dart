import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helpers/database_helper.dart';
import 'package:todo/models/task_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final Function updateTaskList;

  const AddTaskScreen({Key key, this.task, this.updateTaskList})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority = '';
  String _link = '';
  DateTime _date = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Weekly', 'Biweekly', 'Triweekly'];

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title $_date $_link $_priority');

      //insert the task to our user's database
      Task task = Task(
        title: _title,
        date: _date,
        link: _link,
        priority: _priority,
      );
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        //update the task
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _link = widget.task.link;
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormat.format(_date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                widget.task == null
                    ? SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.red],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () => launchURL(_link),
                          child: Text(
                            'Go to Class Link',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                /*
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: TextStyle(color: Colors.white),
                        text: "Class Link"),
                    TextSpan(
                        style: TextStyle(color: Colors.white),
                        text: "Click here",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            var url = "https://www.google.com";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          })
                  ])),
                ),
                */
                SizedBox(
                  height: 40,
                ),
                Text(widget.task == null ? 'Add Class' : 'Update Class',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a class name"
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: _handleDatePicker,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a task"
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Link',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a class link"
                              : null,
                          onSaved: (input) => _link = input,
                          initialValue: _link,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items: _priorities.map((String priority) {
                            return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ));
                          }).toList(),
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Class Frequency',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => _priority == null
                              ? "Please Select a class frequency"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          onPressed: _submit,
                          child: Text(
                            widget.task == null ? "Add" : 'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      widget.task == null
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: FlatButton(
                                onPressed: _delete,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
