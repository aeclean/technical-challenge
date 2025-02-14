class Todo {
  final String uuid;
  final String title;
  final bool isChecked;

  Todo({
    required this.uuid,
    required this.title,
    required this.isChecked,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    uuid: json["uuid"],
    title: json["title"],
    isChecked: json["isChecked"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "title": title,
    "isChecked": isChecked,
  };
}
