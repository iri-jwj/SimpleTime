import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://AnnualPlanDetail')
class AnnualPlanDetail extends StatefulWidget {
  AnnualPlanDetail(this._option);

  final ProjectRouterOption _option;

  @override
  _AnnualPlanDetailState createState() => _AnnualPlanDetailState();
}

class _AnnualPlanDetailState extends State<AnnualPlanDetail> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Unfinished DetailPage"));
  }
}
