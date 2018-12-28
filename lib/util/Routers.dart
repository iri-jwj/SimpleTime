import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/Routers.internal.dart';

@ARouteRoot()
class ProjectRouter {
  ARouterInternal internal = ARouterInternalImpl();

  Widget getPage(ProjectRouterOption option) {
    var result = internal.findPage(
        ARouteOption(option.urlPattern, option.params), option);
    if (result.state == ARouterResultState.FOUND) {
      return result.widget;
    } else {
      return null;
    }
  }
}

class ProjectRouterOption {
  String urlPattern;
  Map<String, dynamic> params;

  ProjectRouterOption(this.urlPattern, this.params);
}
