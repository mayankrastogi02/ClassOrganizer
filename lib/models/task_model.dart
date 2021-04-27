class Task {
  int id;
  String title;
  DateTime date;
  String priority;
  String link;
  int status; // 0 - complete, 1- complete

  Task({this.title, this.date, this.priority, this.status, this.link});
  Task.withId(
      {this.id, this.title, this.date, this.priority, this.status, this.link});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    map['link'] = link;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        date: DateTime.parse(map['date']),
        priority: map['priority'],
        link: map['link'],
        status: map['status']);
  }
}
