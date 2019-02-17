import 'package:json_annotation/json_annotation.dart';
import 'package:project_flutter/model/base_model.dart';

part 'personal_schedule_model.g.dart';

@JsonSerializable()
class PersonalScheduleModel extends BaseModel {
  @JsonKey(nullable: false)
  final String id;
  @JsonKey(nullable: false)
  final String title; //标题
  @JsonKey(nullable: true)
  final int isAllDay;
  @JsonKey(nullable: true)
  final DateTime startTime;
  @JsonKey(nullable: true)
  final String remark;

  PersonalScheduleModel(this.id, this.title, this.isAllDay,
      {this.startTime, this.remark});

  factory PersonalScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalScheduleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonalScheduleModelToJson(this);
}
