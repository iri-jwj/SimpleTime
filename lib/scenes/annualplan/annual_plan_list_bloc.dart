import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/sql/sql_entity.dart';
import 'package:project_flutter/sql/sql_helper.dart';
import 'package:rxdart/rxdart.dart';

class AnnualPlanBloc extends BaseBloc {
  bool isInit = true;
  BasicSqlHelper _helper = BasicSqlHelper(BasicDatabase.instance);
  List<AnnualPlanModel> planList = List<AnnualPlanModel>();

  var _annualPlanListController = BehaviorSubject<List<AnnualPlanModel>>();

  Sink get planListSink => _annualPlanListController.sink;

  Observable<List<AnnualPlanModel>> get planListStream =>
      _annualPlanListController.stream;

  void removePlan(AnnualPlanModel targetToRemove) {
    planList.remove(targetToRemove);
    planListSink.add(planList);
  }

  editPlan(AnnualPlanModel targetEdited) {}

  loadPlans() async {
    /*await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.2, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.3, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.4, false).toJson());
    await _helper.insert(AnnualPlanSqlHelper.TABLE_NAME, AnnualPlanModel(Uuid().v1().toString(), "读书1", 0.1, false).toJson());*/
    var queryResult = await _helper.query(AnnualPlanSqlEntity.TABLE_NAME);
    List<AnnualPlanModel> newModels = List();
    queryResult.forEach((oneEntity) {
      newModels.add(AnnualPlanModel.fromJson(oneEntity));
    });
    planList.clear();
    planList.addAll(newModels);
    planListSink.add(planList);
  }

  addOnePlan(AnnualPlanModel plan) async {
    var insertResult =
        await _helper.insert(AnnualPlanSqlEntity.TABLE_NAME, plan.toJson());
    if (insertResult <= 0) {}
  }

  depose() {
    _annualPlanListController.close();
  }
}
