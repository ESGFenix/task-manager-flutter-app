// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  json['title'] as String,
  json['description'] as String,
  json['dueDate'] == null ? null : DateTime.parse(json['dueDate'] as String),
  done: json['done'] as bool? ?? false,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'done': instance.done,
  'category': _$CategoryEnumMap[instance.category]!,
  'dueDate': instance.dueDate?.toIso8601String(),
};

const _$TaskJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'title': {'type': 'string'},
    'description': {'type': 'string'},
    'done': {'type': 'boolean', 'default': false},
    'category': {'type': 'object'},
    'dueDate': {'type': 'string', 'format': 'date-time'},
  },
  'required': ['title', 'description', 'category', 'dueDate'],
};

const _$CategoryEnumMap = {
  Category.PENDING: 'PENDING',
  Category.DONE: 'DONE',
  Category.LATE: 'LATE',
};
