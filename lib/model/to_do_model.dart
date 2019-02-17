import 'package:json_annotation/json_annotation.dart';
import 'package:project_flutter/model/base_model.dart';

part 'to_do_model.g.dart';

@JsonSerializable()
class ToDoModel extends BaseModel {
  @JsonKey(nullable: false)
  final String id;
  @JsonKey(nullable: false)
  final String title; //标题
  @JsonKey(nullable: false)
  final int importance;
  @JsonKey(nullable: true)
  final DateTime remindTime;
  @JsonKey(nullable: true)
  final String content;

  ToDoModel(this.id, this.title, this.importance,
      {this.remindTime, this.content});

  factory ToDoModel.fromJson(Map<String, dynamic> json) =>
      _$ToDoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ToDoModelToJson(this);
}
