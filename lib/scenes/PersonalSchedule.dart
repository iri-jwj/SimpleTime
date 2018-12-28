import 'package:flutter/material.dart';
import 'package:project_flutter/main.dart';

class PersonalSchedule extends StatefulWidget {
  @override
  _PersonalScheduleState createState() => _PersonalScheduleState();
}

class _PersonalScheduleState extends State<PersonalSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("日程管理"),
        centerTitle: true,
      ),
      body: Container(
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
      ),
    );
  }
}

class TestTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "日程管理",
      home: PersonalSchedule(),
      routes: <String, WidgetBuilder>{"home": (_) => MyApp()},
    );
  }
}
