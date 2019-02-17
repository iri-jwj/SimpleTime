// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalScheduleModel _$PersonalScheduleModelFromJson(
    Map<String, dynamic> json) {
  return PersonalScheduleModel(
      json['id'] as String, json['title'] as String, json['isAllDay'] as int,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      remark: json['remark'] as String);
}

Map<String, dynamic> _$PersonalScheduleModelToJson(
        PersonalScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isAllDay': instance.isAllDay,
      'startTime': instance.startTime?.toIso8601String(),
      'remark': instance.remark
    };
