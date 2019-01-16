import 'package:json_annotation/json_annotation.dart';

part 'AnnualPlanModel.g.dart';

@JsonSerializable(nullable: false)
class AnnualPlanModel {
  final String title; //标题
  final bool isCyclePlan; //是否是周期性计划
  final PlanCycle cycle; //周期
  final DateTime remindDate; //提醒日期
  final String remark; //备注
  final PlanRemindOpportunity remindOpportunity; //提醒时机
  final bool isAutoDelay; //自动延期
  final bool lastDayRemind; //最后一日提醒
  final DateTime whenToStart; //何时开始
  final bool isAllYearPlan; //是否全年计划
  final int lastTimes; //持续周期数
  AnnualPlanModel(
      this.title,
      this.isCyclePlan,
      this.cycle,
      this.remindDate,
      this.remark,
      this.remindOpportunity,
      this.isAutoDelay,
      this.lastDayRemind,
      this.whenToStart,
      this.isAllYearPlan,
      this.lastTimes);

  factory AnnualPlanModel.fromJson(Map<String, dynamic> json) =>
      _$AnnualPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnualPlanModelToJson(this);
}

enum PlanCycle { week, day, month }

enum PlanRemindOpportunity { early, middle, end }
