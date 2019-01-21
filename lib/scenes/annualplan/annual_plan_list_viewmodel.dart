import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/scenes/base_viewmodel.dart';
import 'package:project_flutter/sql/annual_plan_sql_helper.dart';
import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/util/bool_int_converter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class AnnualPlanViewModel extends BaseViewModel {
  bool isInit = true;
  AnnualPlanSqlHelper _helper = AnnualPlanSqlHelper(BasicDatabase.instance);
  List<AnnualPlanModel> planList = List<AnnualPlanModel>();

  var _annualPlanListController = BehaviorSubject<List<AnnualPlanModel>>();

  Sink get putPlanListController => _annualPlanListController.sink;

  Observable<List<AnnualPlanModel>> get getPlanList =>
      Observable(_annualPlanListController.stream);

  void removePlan(AnnualPlanModel targetToRemove) {
    planList.remove(targetToRemove);
    putPlanListController.add(planList);
  }

  void editPlan(AnnualPlanModel targetEdited) {}

  loadPlans() async {
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.2, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.3, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.4, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.1, false).toJson());
    var queryResult = await _helper.query(AnnualPlanSqlHelper.TABLE_NAME);
    List<AnnualPlanModel> newModels = List();
    queryResult.forEach((oneEntity) {
      newModels.add(AnnualPlanModel.fromJson(
          BoolIntConverter.mapConvertInt2Bool(oneEntity, [
        "isCyclePlan",
        "isAutoDelay",
        "lastDayRemind",
        "isAllYearPlan"
      ])));
    });
    planList.clear();
    planList.addAll(newModels);
    putPlanListController.add(planList);
  }

  depose() {
    _annualPlanListController.close();
  }
}
