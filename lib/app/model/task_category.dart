import 'package:json_annotation/json_annotation.dart';

part 'task_category.g.dart';

@JsonSerializable()
class TaskCategory {
  const TaskCategory({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory TaskCategory.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCategoryToJson(this);
}