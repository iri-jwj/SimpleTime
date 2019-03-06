import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/customwidget/fillet_linear_progress_indicator.dart';
import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/scenes/annualplan/annual_plan_list_bloc.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://AnnualPlan')
class AnnualPlanPage extends StatefulWidget {
  AnnualPlanPage(this._option);

  final ProjectRouterOption _option;

  @override
  State createState() => _AnnualPlanPageState();
}

class _AnnualPlanPageState extends State<AnnualPlanPage> {
  var _annualPlanBloc = AnnualPlanBloc();

  @override
  void initState() {
    super.initState();
    _annualPlanBloc.loadPlans();
  }

  Widget _getNoPlansWidget(BuildContext context) {
    return Center(
        child: FlatButton(
      child: Text("add"),
      onPressed: () {
        _annualPlanBloc.loadPlans();
      },
    ));
  }

  Widget _getPlanItem(AnnualPlanModel plan, BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setWidth(204),
      width: ScreenUtil.instance.setWidth(1080),
      margin: EdgeInsets.only(
          top: ScreenUtil.instance.setWidth(47),
          left: ScreenUtil.instance.setWidth(16),
          right: ScreenUtil.instance.setWidth(16)),
      decoration: BoxDecoration(
          color: Color.fromRGBO(86, 164, 252, 0.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color.fromRGBO(86, 164, 252, 0.3),
                offset: Offset(3, 3),
                blurRadius: 3)
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.instance.setWidth(10)))),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
                width: ScreenUtil.instance.setWidth(1080),
                padding: EdgeInsets.only(
                    top: ScreenUtil.instance.setWidth(28),
                    left: ScreenUtil.instance.setWidth(50)),
                child: Text(
                  "${plan.title}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(36),
                      color: Color(0xff101010)),
                )),
          ),
          Flexible(
            child: Container(
              width: ScreenUtil.instance.setWidth(540),
              height: ScreenUtil.instance.setWidth(30),
              margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(47)),
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: RoundedLinearProgressIndicator(
                            value: plan.progress,
                            backgroundColor: Color(0xffffffff),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffffb13e)),
                            radius: 5,
                            width: ScreenUtil.instance.setWidth(540),
                            height: ScreenUtil.instance.setWidth(15)),
                      ),
                      Text(
                        "${plan.progress * 100}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(20)),
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
    return StreamBuilder<List<AnnualPlanModel>>(
        stream: _annualPlanBloc.planListStream,
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
