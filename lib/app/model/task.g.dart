// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  json['title'] as String,
  json['description'] as String,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  done: json['done'] as bool? ?? false,
  categoryId: json['categoryId'] as String? ?? 'uncategorized',
  taskState: $enumDecode(_$TaskStateEnumMap, json['taskState']),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'done': instance.done,
  'taskState': _$TaskStateEnumMap[instance.taskState]!,
  'categoryId': instance.categoryId,
  'dueDate': instance.dueDate?.toIso8601String(),
};

const _$TaskJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'title': {'type': 'string'},
    'description': {'type': 'string'},
    'done': {'type': 'boolean', 'default': false},
    'taskState': {'type': 'object'},
    'categoryId': {'type': 'string', 'default': 'uncategorized'},
    'dueDate': {'type': 'string', 'format': 'date-time'},
  },
  'required': ['title', 'description', 'taskState'],
};

const _$TaskStateEnumMap = {
  TaskState.PENDING: 'PENDING',
  TaskState.DONE: 'DONE',
  TaskState.LATE: 'LATE',
};
