import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helpers/database_helper.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                  '${_dateFormat.format(task.date)} | ${task.priority}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[300],
                      decoration: task.status == 0
                          ? TextDecoration.none
                          : TextDecoration.lineThrough)),
              trailing: Checkbox(
                  onChanged: (value) {
                    task.status = value ? 1 : 0;
                    DatabaseHelper.instance.updateTask(task);
                    _updateTaskList();
                    print(value);
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: task.status == 1 ? true : false),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => AddTaskScreen(
                            task: task,
                            updateTaskList: _updateTaskList,
                          ))),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                      )));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 80),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Classes',
                          style: TextStyle(
                            fontSize: 40,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$completedTaskCount of ${snapshot.data.length}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  );
                }
                return _buildTask(snapshot.data[i - 1]);
              },
            );
          }),
    );
  }
}
