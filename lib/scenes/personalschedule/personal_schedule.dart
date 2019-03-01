import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/scenes/personalschedule/personal_schedule_bloc.dart';
import 'package:project_flutter/util/routers.dart';
import 'package:uuid/uuid.dart';

@ARoute(url: 'projectFlutter://PersonalSchedule')
class PersonalSchedule extends StatefulWidget {
  PersonalSchedule(this._option);

  final ProjectRouterOption _option;

  @override
  _PersonalScheduleState createState() => _PersonalScheduleState();
}

class _PersonalScheduleState extends State<PersonalSchedule> {
  DateTime currentSelectTime;

  Widget _getCalendar(PersonalScheduleBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(8)),
      child: CalendarCarousel(
        showHeader: false,
        height: ScreenUtil.instance.setWidth(730),
        width: ScreenUtil.instance.setWidth(1080),
        thisMonthDayBorderColor: Color.fromRGBO(187, 187, 187, 1),
        onDayPressed: (DateTime date, _) {
          if (date != currentSelectTime) {
            setState(() => currentSelectTime = date);
            bloc.loadDataByDate(date.year, date.month, date.day);
          }
        },
        selectedDateTime: currentSelectTime,
        dayPadding: 2,
        daysHaveCircularBorder: true,
        childAspectRatio: 1.48,
      ),
    );
  }

  Widget _getToDoList(PersonalScheduleBloc bloc) {
    var testList = <ToDoModel>[
      ToDoModel(Uuid().v1().toString(), "1", 8, 0, remindTime: DateTime.now()),
      ToDoModel(Uuid().v1().toString(), "2", 8, 0, remindTime: DateTime.now()),
      ToDoModel(Uuid().v1().toString(), "3", 8, 0, remindTime: DateTime.now())
    ];
    return Container(
        width: ScreenUtil.instance.setWidth(540),
        height: ScreenUtil.instance.setHeight(970),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.instance.setWidth(30),
                  bottom: ScreenUtil.instance.setWidth(75)),
              child: Center(
                child: Text(
                  "ToDo",
                  style: TextStyle(
                      fontSize: ScreenUtil.instance.setHeight(48),
                      color: Color.fromRGBO(108, 108, 108, 1)),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ToDoModel>>(
                stream: bloc.toDoStream,
                builder: (context, snapshot) {

                  if (true) {
                    return ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return _getToDoListItem(testList[index], bloc);
                        });
                  } else {
                    return Center(
                      child: Text("今日无任务"),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget _getToDoListItem(ToDoModel todo, PersonalScheduleBloc bloc) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
              value: todo.isFinished == 1,
              onChanged: (bool) {
                if (bool) {
                  bloc.finishToDo(todo.id);
                }
              }),
          Expanded(
            child:Center(
              child:  Text(
                todo.title,
                style: TextStyle(fontSize: 28, color: Color.fromRGBO(0, 0, 0, 0.87)),
                overflow: TextOverflow.ellipsis,
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _getScheduleList(PersonalScheduleBloc bloc) {
    return StreamBuilder(
      stream: bloc.scheduleStream,
      builder: (context, snapshot) {
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PersonalScheduleBloc bloc = BlocProvider.of(context);
    return Column(
      children: <Widget>[
        _getCalendar(bloc),
        Expanded(
            child: Container(
                color: Color.fromRGBO(86, 164, 252, 0.1),
                child: Row(
                  children: <Widget>[
                    _getToDoList(bloc),
                    Container(width: 1,color: Color.fromRGBO(170, 170, 170, 1),),
                    _getScheduleList(bloc)
                  ],
                )))
      ],
    );
  }
}
