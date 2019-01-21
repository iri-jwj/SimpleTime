import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://AddNormalAnnualPlan')
class AddNormalAnnualPlan extends StatefulWidget {
  AddNormalAnnualPlan(this._option);

  final ProjectRouterOption _option;

  @override
  _AddNormalAnnualPlanState createState() => _AddNormalAnnualPlanState();
}

class _AddNormalAnnualPlanState extends State<AddNormalAnnualPlan> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
