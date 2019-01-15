import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/util/Routers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(myKey: key, title: 'Simple Time'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.myKey, this.title}) : super(key: myKey);

  final String title;
  final Key myKey;

  @override
  _MyHomePageState createState() {
    _MyHomePageState.key = myKey;
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  static Key key;

  Widget _showingPage = ProjectRouter()
      .getPageByName("PersonalSchedule", <String, dynamic>{'key': key});

  void onTapListener(){

  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new Container(
              height: ScreenUtil().setHeight(164),
              child: new Center(
                child: new Text("MenuList", textAlign: TextAlign.center),
              ),
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("日程与to-dos", textAlign: TextAlign.center),
              onTap: () {
                Navigator.of(context).pop();
                ProjectRouter().jumpToByName("PersonalSchedule",
                    <String, dynamic>{'key': widget.myKey}, context);
              },
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("年度计划", textAlign: TextAlign.center),
              onTap: null,
              selected: true,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
                title: new Text("同步", textAlign: TextAlign.center),
                onTap: () {
                  Navigator.of(context).pop();
                  ProjectRouter().jumpToByName("synchronize",
                      <String, dynamic>{'key': widget.myKey}, context);
                }),
            new Divider(
              height: 1,
            ),
          ],
        ),
      ),
      body: Container(
        child: _showingPage,
      ),
    );
  }
}
