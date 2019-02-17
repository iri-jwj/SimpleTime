// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedTableModel _$UpdatedTableModelFromJson(Map<String, dynamic> json) {
  return UpdatedTableModel(json['id'] as String, json['tableName'] as String,
      json['method'] as String, json['isUpToDate'] as int);
}

Map<String, dynamic> _$UpdatedTableModelToJson(UpdatedTableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'method': instance.method,
      'isUpToDate': instance.isUpToDate
    };
