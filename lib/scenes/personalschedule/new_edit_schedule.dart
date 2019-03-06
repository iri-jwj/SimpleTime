import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/util/routers.dart';

@ARoute(url: 'projectFlutter://NewEditSchedule')
class NewEditSchedule extends StatefulWidget {
  NewEditSchedule(this._option);

  final ProjectRouterOption _option;

  @override
  _NewEditScheduleState createState() => _NewEditScheduleState();
}

class _NewEditScheduleState extends State<NewEditSchedule> {
  GlobalKey _formKey= new GlobalKey<FormState>();
  bool isAllDay = false;

  Widget _getDecoratedWidget(Widget child) {
    return Container(
      width: ScreenUtil.instance.setWidth(979),
      height: ScreenUtil.instance.setWidth(100),
      margin: EdgeInsets.only(
          top: ScreenUtil.instance.setWidth(88),
          left: ScreenUtil.instance.setWidth(50)),
      decoration: BoxDecoration(
          color: Color.fromRGBO(86, 164, 252, 0.5),
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.circular(ScreenUtil.instance.setWidth(10))),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          _getDecoratedWidget(Row(
            children: <Widget>[
              Flexible(
                child: Text("标题"),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "输入标题"
                ),
                validator: (title){
                  return title.length>0?null:"标题不能为空";
                },
              ),
            ],
          )),
          _getDecoratedWidget(Row(
            children: <Widget>[
              Flexible(
                child: Text("日期"),
              ),
              Text(widget._option.params["Date"])
            ],
          )),
          _getDecoratedWidget(Row(
            children: <Widget>[
              Flexible(
                child: Text("全天活动"),
              ),
              Checkbox(
                value: isAllDay,
                onChanged: (bool){
                  setState(() {
                    isAllDay = bool;
                  });
                },
              )
            ],
          )),
          isAllDay?null:_getDecoratedWidget(Row(
            
          )),
        ],
      ),
    );
  }
}
