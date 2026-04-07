import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(createJsonSchema: true)
class Task{
  Task(this.title, this.description, this.dueDate, {this.done = false, required this.category,});
  final String title;
  String description;
  bool done;
  Category category;
  DateTime? dueDate;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
enum Category{
  PENDING, DONE, LATE
}