// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDoModel _$ToDoModelFromJson(Map<String, dynamic> json) {
  return ToDoModel(
      json['id'] as String, json['title'] as String, json['importance'] as int,
      remindTime: json['remindTime'] == null
          ? null
          : DateTime.parse(json['remindTime'] as String),
      content: json['content'] as String);
}

Map<String, dynamic> _$ToDoModelToJson(ToDoModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'importance': instance.importance,
      'remindTime': instance.remindTime?.toIso8601String(),
      'content': instance.content
    };
