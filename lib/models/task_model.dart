class Task {
  int id;
  String title;
  DateTime date;
  String link;
  String priority;
  int status; // 0 - complete, 1- complete

  Task({
    this.title,
    this.date,
    this.link,
    this.priority,
    this.status,
  });
  Task.withId({
    this.id,
    this.title,
    this.date,
    this.link,
    this.priority,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['link'] = link;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        date: DateTime.parse(map['date']),
        link: map['link'],
        priority: map['priority'],
        status: map['status']);
  }
}
