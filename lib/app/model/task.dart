import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(createJsonSchema: true)
class Task{
  Task(
      this.title,
      this.description, {
        this.dueDate,
        this.done = false,
        this.categoryId = 'uncategorized',
        required this.taskState,}
      );
  final String title;
  String description;
  bool done;
  TaskState taskState;
  @JsonKey(defaultValue: 'uncategorized')
  String categoryId;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? dueDate;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
enum TaskState{
  PENDING, DONE, LATE
}