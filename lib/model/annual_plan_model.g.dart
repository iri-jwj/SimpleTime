// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualPlanModel _$AnnualPlanModelFromJson(Map<String, dynamic> json) {
  return AnnualPlanModel(json['id'] as String, json['title'] as String,
      (json['progress'] as num).toDouble(), json['isCyclePlan'] as int,
      cycle: _$enumDecodeNullable(_$PlanCycleEnumMap, json['cycle']),
      remindDate: json['remindDate'] == null
          ? null
          : DateTime.parse(json['remindDate'] as String),
      remark: json['remark'] as String,
      remindOpportunity: _$enumDecodeNullable(
          _$PlanRemindOpportunityEnumMap, json['remindOpportunity']),
      isAutoDelay: json['isAutoDelay'] as int,
      lastDayRemind: json['lastDayRemind'] as int,
      whenToStart: json['whenToStart'] == null
          ? null
          : DateTime.parse(json['whenToStart'] as String),
      isAllYearPlan: json['isAllYearPlan'] as int,
      lastTimes: json['lastTimes'] as int);
}

Map<String, dynamic> _$AnnualPlanModelToJson(AnnualPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCyclePlan': instance.isCyclePlan,
      'cycle': _$PlanCycleEnumMap[instance.cycle],
      'remindDate': instance.remindDate?.toIso8601String(),
      'remark': instance.remark,
      'remindOpportunity':
          _$PlanRemindOpportunityEnumMap[instance.remindOpportunity],
      'isAutoDelay': instance.isAutoDelay,
      'lastDayRemind': instance.lastDayRemind,
      'whenToStart': instance.whenToStart?.toIso8601String(),
      'isAllYearPlan': instance.isAllYearPlan,
      'lastTimes': instance.lastTimes,
      'progress': instance.progress
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

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
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
