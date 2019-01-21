
import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://AddExtendsAnnualPlan')
class AddExtendsAnnualPlan extends StatefulWidget {
  AddExtendsAnnualPlan(this._option);

  final ProjectRouterOption _option;

  @override
  _AddExtendsAnnualPlanState createState() => _AddExtendsAnnualPlanState();
}

class _AddExtendsAnnualPlanState extends State<AddExtendsAnnualPlan> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
