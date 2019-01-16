import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/util/Routers.dart';

@ARoute(url: 'projectFlutter://PersonalSchedule')
class PersonalSchedule extends StatefulWidget {
  PersonalSchedule(this._option);

  final ProjectRouterOption _option;

  @override
  _PersonalScheduleState createState() => _PersonalScheduleState();
}

class _PersonalScheduleState extends State<PersonalSchedule> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Center(
            child: IconButton(
              color: Color.fromARGB(255, 0, 255, 255),
              icon: Icon(Icons.add),
              tooltip: 'to Add microsoft account',
              onPressed: () => Navigator.of(context).pushNamed("home"),
              highlightColor: Color.fromARGB(255, 0, 255, 255),
              disabledColor: Color.fromARGB(255, 0, 0, 255),
              splashColor: Color.fromARGB(255, 0, 255, 0),
            ),
          ),
        ],
      ),
    );
  }
}
