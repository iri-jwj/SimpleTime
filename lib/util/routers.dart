import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/routers.internal.dart';

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

  void jumpTobyOption(ProjectRouterOption option, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return getPage(option);
    }));
  }

  void jumpToByName(
      String target, Map<String, dynamic> params, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return getPage(ProjectRouterOption("projectFlutter://$target", params));
    }));
  }

  Widget getPageByName(String target, Map<String, dynamic> params) {
    ProjectRouterOption option =
        ProjectRouterOption("projectFlutter://$target", params);
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
