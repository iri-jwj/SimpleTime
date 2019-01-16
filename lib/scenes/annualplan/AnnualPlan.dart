import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/Routers.dart';

@ARoute(url: 'projectFlutter://AnnualPlan')
class AnnualPlanPage extends StatefulWidget {
  AnnualPlanPage(this._option);

  final ProjectRouterOption _option;

  @override
  State createState() => _AnnualPlanPageState();
}

class _AnnualPlanPageState extends State<AnnualPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("annual plan"),
    );
  }
}
