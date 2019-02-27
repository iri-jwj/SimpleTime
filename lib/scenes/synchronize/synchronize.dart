import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/customwidget/progress_dialog_stack.dart';
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

  Container c;
  CircularProgressIndicator _circularProgressIndicator =
      CircularProgressIndicator(
    strokeWidth: 5,
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffb13e)),
    backgroundColor: Color(0xff6C6C6C),
  );

  Widget getLoginContainer(SynchronizeBloc bloc) {
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil.instance.setWidth(117),
          left: ScreenUtil.instance.setWidth(90)),
      height: ScreenUtil.instance.setWidth(100),
      width: ScreenUtil.instance.setWidth(900),
      decoration: BoxDecoration(
        color: Color.fromRGBO(86, 164, 252, 0.5),
        boxShadow: getBoxShadows(),
        shape: BoxShape.rectangle,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil.instance.setWidth(10))),
      ),
      child: GestureDetector(
        child: Center(
          child: Text(
            "绑定OneDrive账号",
            style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
          ),
        ),
        onTap: () {
          bloc.nativeLogin();
        },
      ),
    );
  }

  Widget getHasLoginContainer(SynchronizeBloc bloc) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(117)),
        height: ScreenUtil.instance.setWidth(100),
        width: ScreenUtil.instance.setWidth(900),
        decoration: BoxDecoration(
          color: Color.fromRGBO(86, 164, 252, 0.5),
          boxShadow: getBoxShadows(),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.instance.setWidth(10))),
        ),
        child: GestureDetector(
          child: Text(
            "ID:${bloc.getAccount()}",
            style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
          ),
          onTap: () {
            bloc.nativeLogin();
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(117)),
        height: ScreenUtil.instance.setWidth(100),
        width: ScreenUtil.instance.setWidth(900),
        decoration: BoxDecoration(
          color: Color.fromRGBO(86, 164, 252, 0.5),
          boxShadow: getBoxShadows(),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.instance.setWidth(10))),
        ),
        child: GestureDetector(
          child: Text(
            "退出",
            style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
          ),
          onTap: () {
            bloc.nativeLogout();
          },
        ),
      )
    ]);
  }

  Widget getLoading(SynchronizeBloc bloc) {
    return Container(
      child: ProgressDialogStack(
          _circularProgressIndicator, getLoginContainer(bloc)),
    );
  }

  List<BoxShadow> getBoxShadows() {
    return [
      BoxShadow(
          color: Color.fromRGBO(86, 164, 252, 0.3),
          offset: Offset(3, 3),
          blurRadius: 3)
    ];
  }

  SnackBar getSnackBar(String content) {
    return SnackBar(
      content: Text(content),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    SynchronizeBloc _bloc = BlocProvider.of<SynchronizeBloc>(context);
    String account = _bloc.getAccount();

    return StreamBuilder<String>(
      stream: _bloc.synchronizeStream,
      builder: (context, streamSnap) {
        String state = streamSnap.data;
        if (state == SynchronizeBloc.LOADING) {
          return getLoading(_bloc);
        }

        switch (state) {
          case SynchronizeBloc.LOADING:
            return getLoading(_bloc);
          case SynchronizeBloc.HAS_LOGIN:
            return getHasLoginContainer(_bloc);
          case SynchronizeBloc.NEED_LOGIN_AGAIN:
            showDialog(
                context: context,
                builder: (buildContext) {
                  AlertDialog(
                    content: Text("登录已过期，请重新登录"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("取消"),
                        onPressed: () {
                          dispose();
                        },
                      ),
                      FlatButton(
                        child: Text("登录"),
                        onPressed: () {
                          dispose();
                        },
                      )
                    ],
                    contentTextStyle:
                        TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
                  );
                });
            break;
          case SynchronizeBloc.LOGIN_ERROR:
            Scaffold.of(context).showSnackBar(getSnackBar("登录出现错误，请重试"));

            break;
          default:
            {
              if (account != null && account != "") {
                return getHasLoginContainer(_bloc);
              } else {
                return getLoginContainer(_bloc);
              }
            }
        }
      },
    );
  }
}
