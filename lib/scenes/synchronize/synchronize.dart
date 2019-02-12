import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/scenes/synchronize/synchronize_bloc.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://synchronize')
class SynchronizePage extends StatefulWidget {
  SynchronizePage(this.option) : super(key: option.params["key"]);
  final ProjectRouterOption option;

  @override
  _SynchronizeState createState() => _SynchronizeState();
}

class _SynchronizeState extends State<SynchronizePage> {
  bool requestResult = true;
  SnackBar snackBar = SnackBar(
    content: Text("绑定失败"),
    duration: Duration(milliseconds: 1500),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    SynchronizeBloc _bloc = BlocProvider.of<SynchronizeBloc>(context);
    //阴影配置
    List<BoxShadow> shadows = List<BoxShadow>();
    shadows.add(BoxShadow(
        color: Color.fromRGBO(86, 164, 252, 0.3),
        offset: Offset(3, 3),
        blurRadius: 3));

    //界面内容
    Container c = Container(
      margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(117)),
      height: ScreenUtil.instance.setWidth(900),
      width: ScreenUtil.instance.setWidth(900),
      decoration: BoxDecoration(
        color: Color.fromRGBO(86, 164, 252, 0.5),
        boxShadow: shadows,
        shape: BoxShape.rectangle,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil.instance.setWidth(10))),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Text(
              "绑定OneDrive账号",
              style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
            ),
            onTap: () {
              _bloc.jumpToNative();
            },
          ),
          Container(
            child: GestureDetector(
              child: Text("createFile"),
              onTap: () {
                _bloc.uploadData(() {}, () {});
              },
            ),
            margin: EdgeInsets.only(top: 150),
          )
        ],
      ),
    );

    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Center(child: c),
          ],
        ),
      ),
    );
  }
}
