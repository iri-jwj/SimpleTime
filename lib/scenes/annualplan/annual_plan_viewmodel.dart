import 'dart:async';

import 'package:project_flutter/scenes/base_viewmodel.dart';
import 'package:project_flutter/scenes/model/annual_plan_model.dart';
import 'package:rxdart/rxdart.dart';

class AnnualPlanViewModel extends BaseViewModel {
  bool isInit = true;
  List<AnnualPlanModel> planList = List<AnnualPlanModel>();


  var _annualPlanListController = BehaviorSubject<List<AnnualPlanModel>>();
  Sink get putPlanListController => _annualPlanListController.sink;
  Stream<List<AnnualPlanModel>> get getPlanList =>
      _annualPlanListController.stream.map((plansToConvert){
        planList.addAll(plansToConvert);
        return planList;
      });

  var _planRemoveController = PublishSubject<AnnualPlanModel>();
  Sink get removePlanSink => _planRemoveController.sink;
  Stream<AnnualPlanModel> get _removePlanStream => _planRemoveController.stream;

  AnnualPlanViewModel(){
    _removePlanStream.listen((planToRemove){
      planList.remove(planToRemove);
      putPlanListController.add(planList);
    });
  }

  loadPlans() async {
    putPlanListController.add(<AnnualPlanModel>[
      AnnualPlanModel(title: "123", progress: 0.1),
      AnnualPlanModel(title: "456", progress: 0.1),
      AnnualPlanModel(title: "789", progress: 0.1),
      AnnualPlanModel(title: "101010", progress: 0.1)
    ]);
    if (isInit) {
      _annualPlanListController.stream.map((planList) {
        this.planList.addAll(planList);
        isInit = false;
      });
    }
  }

  depose() {
    _annualPlanListController.close();
    _planRemoveController.close();
  }
}
