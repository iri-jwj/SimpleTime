import 'package:json_annotation/json_annotation.dart';

part 'annual_plan_model.g.dart';

@JsonSerializable()
class AnnualPlanModel {
  @JsonKey(nullable: false)
  final String id;
  @JsonKey(nullable: false)
  final String title; //标题
  @JsonKey(nullable: false)
  final bool isCyclePlan; //是否是周期性计划
  @JsonKey(nullable: true)
  final PlanCycle cycle; //周期
  @JsonKey(nullable: true)
  final DateTime remindDate; //提醒日期
  @JsonKey(nullable: true)
  final String remark; //备注
  @JsonKey(nullable: true)
  final PlanRemindOpportunity remindOpportunity; //提醒时机
  @JsonKey(nullable: true)
  final bool isAutoDelay; //自动延期
  @JsonKey(nullable: true)
  final bool lastDayRemind; //最后一日提醒
  @JsonKey(nullable: true)
  final DateTime whenToStart; //何时开始
  @JsonKey(nullable: true)
  final bool isAllYearPlan; //是否全年计划
  @JsonKey(nullable: true)
  final int lastTimes; //持续周期数
  @JsonKey(nullable: false)
  final double progress;

  AnnualPlanModel(this.id, this.title, this.progress, this.isCyclePlan,
      {this.cycle,
      this.remindDate,
      this.remark,
      this.remindOpportunity,
      this.isAutoDelay,
      this.lastDayRemind,
      this.whenToStart,
      this.isAllYearPlan,
      this.lastTimes});

  factory AnnualPlanModel.fromJson(Map<String, dynamic> json) =>
      _$AnnualPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnualPlanModelToJson(this);
}

enum PlanCycle { week, day, month }

enum PlanRemindOpportunity { early, middle, end }
