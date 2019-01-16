// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnnualPlanModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualPlanModel _$AnnualPlanModelFromJson(Map<String, dynamic> json) {
  return AnnualPlanModel(
      json['title'] as String,
      json['isCyclePlan'] as bool,
      _$enumDecode(_$PlanCycleEnumMap, json['cycle']),
      DateTime.parse(json['remindDate'] as String),
      json['remark'] as String,
      _$enumDecode(_$PlanRemindOpportunityEnumMap, json['remindOpportunity']),
      json['isAutoDelay'] as bool,
      json['lastDayRemind'] as bool,
      DateTime.parse(json['whenToStart'] as String),
      json['isAllYearPlan'] as bool,
      json['lastTimes'] as int);
}

Map<String, dynamic> _$AnnualPlanModelToJson(AnnualPlanModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isCyclePlan': instance.isCyclePlan,
      'cycle': _$PlanCycleEnumMap[instance.cycle],
      'remindDate': instance.remindDate.toIso8601String(),
      'remark': instance.remark,
      'remindOpportunity':
          _$PlanRemindOpportunityEnumMap[instance.remindOpportunity],
      'isAutoDelay': instance.isAutoDelay,
      'lastDayRemind': instance.lastDayRemind,
      'whenToStart': instance.whenToStart.toIso8601String(),
      'isAllYearPlan': instance.isAllYearPlan,
      'lastTimes': instance.lastTimes
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

const _$PlanCycleEnumMap = <PlanCycle, dynamic>{
  PlanCycle.week: 'week',
  PlanCycle.day: 'day',
  PlanCycle.month: 'month'
};

const _$PlanRemindOpportunityEnumMap = <PlanRemindOpportunity, dynamic>{
  PlanRemindOpportunity.early: 'early',
  PlanRemindOpportunity.middle: 'middle',
  PlanRemindOpportunity.end: 'end'
};
