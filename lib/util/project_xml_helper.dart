import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/model/base_model.dart';
import 'package:project_flutter/model/personal_schedule_model.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:xml/xml.dart' as xml;

class ProjectXmlHelper {
  static const String tempXmlFileName = "informationToUpload.xml";
  final Map<String, String> _modelTagMap = {
    XmlTag.annualPlan.toString(): "annualPlan",
    XmlTag.personalSchedule.toString(): "personalSchedule",
    XmlTag.todo.toString(): "todo"
  };

  static const String rootTag = "simpletime";

  List<Object> _tempListForBuild = List(10);

  xml.XmlBuilder xmlBuilder;

  ProjectXmlHelper put(List<Object> items, {XmlTag tag, String xmlFileName}) {
    if (xmlBuilder == null) {
      xmlBuilder = xml.XmlBuilder();
      xmlBuilder.processing('xml', 'version="1.0"');
    }
    _tempListForBuild.add(items);
    return this;
  }

  void _buildXmlByModel(List<BaseModel> models) {
    if (models == null && models.length <= 0) {
      return;
    }
    var modelTag;
    if (models[0] is AnnualPlanModel) {
      modelTag = _modelTagMap[XmlTag.annualPlan.toString()];
    } else if (modelTag[0] is ToDoModel) {
      modelTag = _modelTagMap[XmlTag.todo.toString()];
    } else if (modelTag[0] is PersonalScheduleModel) {
      modelTag = _modelTagMap[XmlTag.personalSchedule.toString()];
    }

    xmlBuilder.element(modelTag + "s", nest: () {
      for (BaseModel model in models) {
        Map modelMap = model.toJson();
        Iterable<String> keys = modelMap.keys;
        xmlBuilder.element(modelTag, nest: () {
          keys.forEach((key) {
            xmlBuilder.element(key, nest: modelMap[key] ? modelMap[key] : "");
          });
        });
      }
    });
  }

  void buildXml() {
    if (_tempListForBuild.length <= 0) {
      return;
    }
    xmlBuilder.element(rootTag, nest: () {
      for (var object in _tempListForBuild) {
        if (object is List<BaseModel>) {
          _buildXmlByModel(object);
        }
      }
    });
  }

  void parseXml(String xmlString) {
    var document = xml.parse(xmlString);
    var plans = document.findAllElements(_modelTagMap[XmlTag.annualPlan.toString()]);
    var todos = document.findAllElements(_modelTagMap[XmlTag.todo.toString()]);
    var schedules =
        document.findAllElements(_modelTagMap[XmlTag.personalSchedule.toString()]);
    plans.forEach((plan){

    });
  }
  
  
}

enum XmlTag { annualPlan, todo, personalSchedule }
