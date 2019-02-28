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
  bool _firstInit = true;

  CircularProgressIndicator _circularProgressIndicator =
      CircularProgressIndicator(
    strokeWidth: 5,
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffb13e)),
    backgroundColor: Color(0xff6C6C6C),
  );

  Widget getLoginContainer(SynchronizeBloc bloc, bool showLoginError) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(
              top: ScreenUtil.instance.setWidth(117),
              left: ScreenUtil.instance.setWidth(90)),
          height: ScreenUtil.instance.setWidth(100),
          width: ScreenUtil.instance.setWidth(900),
          decoration: BoxDecoration(
            color: Color.fromRGBO(86, 164, 252, 0.5),
            boxShadow: getBoxShadows(),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.instance.setWidth(10))),
          ),
          child: Center(
            child: Text(
              "绑定OneDrive账号",
              style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
              maxLines: 1,
            ),
          ),
        ),
        onTap: () {
          bloc.nativeLogin();
        });
  }

  Widget getHasLoginContainer(SynchronizeBloc bloc, bool needLoginAgain) {
    return Column(children: <Widget>[
      GestureDetector(
        child: Container(
          margin: EdgeInsets.only(
              top: ScreenUtil.instance.setWidth(117),
              left: ScreenUtil.instance.setWidth(90)),
          height: ScreenUtil.instance.setWidth(100),
          width: ScreenUtil.instance.setWidth(900),
          decoration: BoxDecoration(
            color: Color.fromRGBO(86, 164, 252, 0.5),
            boxShadow: getBoxShadows(),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.instance.setWidth(10))),
          ),
          child: Center(
            child: Text(
              "ID:${bloc.getAccount()}",
              style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
            ),
          ),
        ),
        onTap: () {
          bloc.nativeLogin();
        },
      ),
      GestureDetector(
        child: Container(
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
            child: Center(
              child: Text(
                "退出",
                style: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
              ),
            )),
        onTap: () {
          bloc.nativeLogout();
        },
      ),
    ]);
  }

  Widget getLoading(SynchronizeBloc bloc) {
    return Container(
      child: ProgressDialogStack(
          _circularProgressIndicator, getLoginContainer(bloc, false)),
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

  Future<void> showSnackBar(String content) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1300),
    ));
    return null;
  }

  void _showLoginAgainDialog(SynchronizeBloc bloc) {
    showDialog(
        context: context,
        builder: (buildContext) {
          AlertDialog(
            content: Text("登录已过期，请重新登录"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("登录"),
                onPressed: () {
                  bloc.nativeLogin(true);
                },
              )
            ],
            contentTextStyle: TextStyle(fontSize: 20, color: Color(0xff6c6c6c)),
          );
        });
  }

  void _handleError(String errorMessage, SynchronizeBloc bloc) {
    switch (errorMessage) {
      case SynchronizeBloc.LOGIN_ERROR:
        showSnackBar("登录出现错误，请重试");
        break;
      case SynchronizeBloc.LOGOUT_ERROR:
        showSnackBar("退出发生错误");
        break;
      case SynchronizeBloc.LOGOUT_SUCCESS:
        showSnackBar("退出完成");
        break;
      case SynchronizeBloc.NEED_LOGIN_AGAIN:
        _showLoginAgainDialog(bloc);
        break;
      case SynchronizeBloc.LOGIN_CANCEL:
        showSnackBar("登录取消");
        break;
    }
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
        if (_firstInit) {
          _bloc.errorStream.listen((errorMessage) {
            _handleError(errorMessage, _bloc);
            _bloc.synchronizeSink.add(SynchronizeBloc.NEED_LOGIN);
          });
          _firstInit = false;
        }

        switch (state) {
          case SynchronizeBloc.LOADING:
            return getLoading(_bloc);
          case SynchronizeBloc.HAS_LOGIN:
            return getHasLoginContainer(_bloc, false);
          default:
            {
              if (account != null && account != "") {
                return getHasLoginContainer(_bloc, false);
              } else {
                return getLoginContainer(_bloc, false);
              }
            }
        }
      },
    );
  }
}
