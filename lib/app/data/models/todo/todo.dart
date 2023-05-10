import 'dart:convert';

class Todo {
  int id;
  String title;
  String description;
  bool completed;
  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<Todo> todoFromJson(String str) =>
      List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

  static String todoToJson(List<Todo> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  static Todo singleTodoFromJson(String str) => Todo.fromJson(json.decode(str));

  static String singleTodoToJson(Todo data) => json.encode(data.toJson());

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        completed: json["completed"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "completed": completed,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
