import 'dart:async';

import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/model/base_model.dart';
import 'package:project_flutter/model/personal_schedule_model.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/sql/sql_entity.dart';
import 'package:project_flutter/util/project_xml_helper.dart';

/// 利用ProjectXmlHelper 把数据库中的数据转换为xml文件、字符串
class DatabaseRW {
  final BasicDatabase _basicDatabase;

  DatabaseRW(this._basicDatabase);

  final ProjectXmlHelper xmlHelper = ProjectXmlHelper().init();

  Future<List<int>> databaseToXmlString() async {
    List<int> xmlBytes;
    var annualPlans =
        await _basicDatabase.query(AnnualPlanSqlEntity.TABLE_NAME);
    var todos = await _basicDatabase.query(ToDoSqlEntity.TABLE_NAME);
    var schedules = await _basicDatabase.query(ScheduleSqlEntity.TABLE_NAME);

    List<AnnualPlanModel> annualPlanModel = List();
    annualPlans.forEach((planJson) {
      annualPlanModel.add(AnnualPlanModel.fromJson(planJson));
    });

    List<ToDoModel> toDoModels = List();
    todos.forEach((toDoJson) {
      toDoModels.add(ToDoModel.fromJson(toDoJson));
    });

    List<PersonalScheduleModel> personalModels = List();
    schedules.forEach((scheduleJson) {
      personalModels.add(PersonalScheduleModel.fromJson(scheduleJson));
    });
    xmlHelper..put(annualPlanModel)..put(toDoModels)..put(personalModels);
    xmlBytes = xmlHelper.buildXml();
    return xmlBytes;
  }

  List<int> mapToXmlString(Map<XmlTag, List<BaseModel>> objectMap) {
    objectMap.values.forEach((list) {
      xmlHelper.put(list);
    });

    List<int> xmlBytes = xmlHelper.buildXml();
    return xmlBytes;
  }

  Map<XmlTag, List<BaseModel>> readDataFromXml(
      String xmlString, Map<XmlTag, List<BaseModel>> currentData) {
    Map<XmlTag, List<BaseModel>> parsedResult = xmlHelper.parseXml(xmlString);

    var cleanedList = _cleanSameData(parsedResult, currentData);
    return cleanedList;
  }

  Map<XmlTag, List<BaseModel>> _cleanSameData(
      Map<XmlTag, List<BaseModel>> toClean,
      Map<XmlTag, List<BaseModel>> currentData) {
    var keys = currentData.keys;
    keys.forEach((key) {
      var toCleanList = toClean[key];
      var currentList = currentData[key];

      currentList.forEach((item) {
        for (var i in toCleanList) {
          if (i.id == item.id) {
            toCleanList.remove(i);
          }
        }
      });

      toClean[key] = toCleanList;
    });

    return toClean;
  }
}
