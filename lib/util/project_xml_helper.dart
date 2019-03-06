import 'dart:io';

import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/model/base_model.dart';
import 'package:project_flutter/model/personal_schedule_model.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:project_flutter/sql/sql_entity.dart';
import 'package:xml/xml.dart' as xml;

class ProjectXmlHelper {
  static const String _tempXmlFileName = "informationToUpload.xml";

  String _path;
  File _xmlFile;

  bool _isInit;

  final Map<String, String> _modelTagMap = {
    XmlTag.annualPlan.toString(): "annualPlan",
    XmlTag.personalSchedule.toString(): "personalSchedule",
    XmlTag.todo.toString(): "todo"
  };

  static const String _rootTag = "simpletime";

  List<Object> _tempListForBuild = List();

  final Map<XmlTag, List<BaseModel>> _tempParsedCollection = {
    XmlTag.annualPlan: List<AnnualPlanModel>(),
    XmlTag.todo: List<ToDoModel>(),
    XmlTag.personalSchedule: List<PersonalScheduleModel>()
  };

  xml.XmlBuilder _xmlBuilder;

  ProjectXmlHelper init() {
    pathProvider.getApplicationDocumentsDirectory().then((directory) {
      _path = directory.path;
      if (_xmlFile == null) {
        _xmlFile = File("$_path/$_tempXmlFileName");
      }
      if (!_xmlFile.existsSync()) {
        _xmlFile.createSync();
      }
    });

    _isInit = true;
    return this;
  }

  ProjectXmlHelper put(List<Object> items, {XmlTag tag, String xmlFileName}) {
    if (!_isInit) {
      throw Exception("call init function first");
    }
    if (_xmlBuilder == null) {
      _xmlBuilder = xml.XmlBuilder();
      _xmlBuilder.processing('xml', 'version="1.0"');
    }
    _tempListForBuild.add(items);
    return this;
  }

  void _buildXmlByModel(List<BaseModel> models) {
    if (models == null && models.length <= 0) {
      return;
    }
    var modelTag = _confirmModelTag(models[0]);

    _xmlBuilder.element(modelTag + "s", nest: () {
      for (BaseModel model in models) {
        Map modelMap = model.toJson();
        Iterable<String> keys = modelMap.keys;
        _xmlBuilder.element(modelTag, nest: () {
          keys.forEach((key) {
            _xmlBuilder.element(key, nest: modelMap[key] ? modelMap[key] : "");
          });
        });
      }
    });
  }

  List<int> buildXml() {
    if (!_isInit) {
      throw Exception("call init function first");
    }
    if (_tempListForBuild.length <= 0) {
      return null;
    }
    _xmlBuilder.element(_rootTag, nest: () {
      for (var object in _tempListForBuild) {
        if (object is List<BaseModel>) {
          _buildXmlByModel(object);
        }
      }
    });
    StringBuffer buffer = StringBuffer();

    if (_xmlFile.lengthSync() != 0) {
      _xmlFile.deleteSync();
      _xmlFile.createSync();
    }
    _xmlBuilder.build().writePrettyTo(buffer, 0, '\t');
    _xmlFile.openWrite().write(buffer);
    return _xmlFile.readAsBytesSync();
  }

  String _confirmModelTag(BaseModel item) {
    var modelTag;
    if (item is AnnualPlanModel) {
      modelTag = _modelTagMap[XmlTag.annualPlan.toString()];
    } else if (item is ToDoModel) {
      modelTag = _modelTagMap[XmlTag.todo.toString()];
    } else if (item is PersonalScheduleModel) {
      modelTag = _modelTagMap[XmlTag.personalSchedule.toString()];
    }
    return modelTag;
  }

  Map<XmlTag, List<BaseModel>> parseXml(String xmlString) {
    if (!_isInit) {
      throw Exception("call init function first");
    }
    var document = xml.parse(xmlString);
    var plans =
        document.findAllElements(_modelTagMap[XmlTag.annualPlan.toString()]);
    var todos = document.findAllElements(_modelTagMap[XmlTag.todo.toString()]);
    var schedules = document
        .findAllElements(_modelTagMap[XmlTag.personalSchedule.toString()]);

    _parseXmlByType(plans, XmlTag.annualPlan, [
      AnnualPlanSqlEntity.COLUMN_id,
      AnnualPlanSqlEntity.COLUMN_progress,
      AnnualPlanSqlEntity.COLUMN_lastTimes,
      AnnualPlanSqlEntity.COLUMN_whenToStart,
      AnnualPlanSqlEntity.COLUMN_lastDayRemind,
      AnnualPlanSqlEntity.COLUMN_isAutoDelay,
      AnnualPlanSqlEntity.COLUMN_remindOpportunity,
      AnnualPlanSqlEntity.COLUMN_remark,
      AnnualPlanSqlEntity.COLUMN_remindDate,
      AnnualPlanSqlEntity.COLUMN_cycle,
      AnnualPlanSqlEntity.COLUMN_isCyclePlan,
      AnnualPlanSqlEntity.COLUMN_TITLE
    ]);

    _parseXmlByType(todos, XmlTag.todo, [
      ToDoSqlEntity.COLUMN_TITLE,
      ToDoSqlEntity.COLUMN_id,
      ToDoSqlEntity.TABLE_NAME,
      ToDoSqlEntity.COLUMN_content,
      ToDoSqlEntity.COLUMN_importance,
      ToDoSqlEntity.COLUMN_remindTime
    ]);

    _parseXmlByType(schedules, XmlTag.personalSchedule, [
      ScheduleSqlEntity.TABLE_NAME,
      ScheduleSqlEntity.COLUMN_id,
      ScheduleSqlEntity.COLUMN_remark,
      ScheduleSqlEntity.CREATE_ANNUAL_PLAN_TABLE,
      ScheduleSqlEntity.COLUMN_isAllDay,
      ScheduleSqlEntity.COLUMN_startTime
    ]);

    return _tempParsedCollection;
  }

  void _parseXmlByType(
      Iterable<xml.XmlElement> target, XmlTag tag, Iterable<String> keys) {
    Map<String, dynamic> objectJson = Map();
    var iterator = keys.iterator;
    target.forEach((element) {
      while (iterator.moveNext()) {
        objectJson[iterator.current] =
            element.findAllElements(iterator.current).single.text;
      }
      _saveObjectToCollection(tag, objectJson);
    });
  }

  void _saveObjectToCollection(XmlTag tag, Map<String, dynamic> objectJson) {
    var object;
    switch (tag) {
      case XmlTag.annualPlan:
        {
          object = AnnualPlanModel.fromJson(objectJson);
          break;
        }
      case XmlTag.personalSchedule:
        {
          object = PersonalScheduleModel.fromJson(objectJson);
          break;
        }
      case XmlTag.todo:
        {
          object = ToDoModel.fromJson(objectJson);
          break;
        }
    }
    _tempParsedCollection[tag].add(object);
  }
}

enum XmlTag { annualPlan, todo, personalSchedule }
