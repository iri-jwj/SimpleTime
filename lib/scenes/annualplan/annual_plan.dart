import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/scenes/annualplan/annual_plan_viewmodel.dart';
import 'package:project_flutter/scenes/model/annual_plan_model.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://AnnualPlan')
class AnnualPlanPage extends StatefulWidget {
  AnnualPlanPage(this._option);

  final ProjectRouterOption _option;

  @override
  State createState() => _AnnualPlanPageState();
}

class _AnnualPlanPageState extends State<AnnualPlanPage> {
  var _viewModel = AnnualPlanViewModel();
  var _viewModelStream;

  @override
  void initState() {
    super.initState();
    _viewModelStream = _viewModel.getPlanList;
    _viewModel.loadPlans();
  }

  Widget _getNoPlansWidget(BuildContext context) {
    return Center(
        child: FlatButton(
      child: Text("add"),
      onPressed: () {
        _viewModel.loadPlans();
      },
    ));
  }

  Widget _getPlanItem(AnnualPlanModel plan, BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setWidth(204),
      width: ScreenUtil.instance.setWidth(1080),
      margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(47)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(86, 164, 252, 100),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color.fromRGBO(86, 164, 252, 50),
                offset: Offset(0, 0),
            )
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.instance.setWidth(10)))),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil.instance.setWidth(28),
                    left: ScreenUtil.instance.setWidth(50)),
                child: Text(
                  "${plan.title}",
                  style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(36),
                      color: Color(0xff101010)),
                )),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(10)),
              child: Center(
                child: Row(children: <Widget>[
                  Flexible(
                    child: LinearProgressIndicator(
                      value: plan.progress,
                      backgroundColor: Color(0xffffffff),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffffb13e)),
                    ),
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);

    return StreamBuilder<List<AnnualPlanModel>>(
        stream: _viewModelStream,
        builder: (context, planList) {
          List<AnnualPlanModel> plans = planList.data;
          if (plans == null || plans.length == 0) {
            return _getNoPlansWidget(context);
          } else {
            return ListView.builder(
                itemCount: plans?.length ?? 0,
                itemBuilder: (context, index) {
                  if (plans.length == 0) {
                    return _getNoPlansWidget(context);
                  }
                  return _getPlanItem(plans[index], context);
                });
          }
        });
  }
}
