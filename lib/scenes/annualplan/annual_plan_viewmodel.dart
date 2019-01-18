import 'package:project_flutter/scenes/base_viewmodel.dart';
import 'package:project_flutter/scenes/model/annual_plan_model.dart';
import 'package:rxdart/rxdart.dart';

class AnnualPlanViewModel extends BaseViewModel {
  bool isInit = true;
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
    planList.addAll(<AnnualPlanModel>[
      AnnualPlanModel(title: "读书1", progress: 0.1),
      AnnualPlanModel(title: "读书4", progress: 0.1),
      AnnualPlanModel(title: "读书3", progress: 0.1),
      AnnualPlanModel(title: "读书2", progress: 0.1)
    ]);
    putPlanListController.add(planList);
  }

  depose() {
    _annualPlanListController.close();
  }
}
