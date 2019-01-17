import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/util/routers.dart';

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

  final Map<String, int> _mapping = {
    'PersonalSchedule': 1,
    'AnnualPlan': 2,
    'synchronize': 4
  };

  int _selectedPage = 1;
  String _title = "日程与to-dos";

  void _onTapListener(BuildContext context, String targetPage,
      Map<String, dynamic> params, String title) {
    Navigator.of(context).pop();
    setState(() {
      _title = title;
      _showingPage = ProjectRouter().getPageByName(targetPage, params);
      _updateCheckItem(targetPage);
    });
  }

  void _updateCheckItem(String targetPage) {
    _selectedPage = _mapping[targetPage];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
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
                _onTapListener(context, "PersonalSchedule",
                    <String, dynamic>{'key': widget.myKey}, "日程与to-dos");
              },
              selected: 1 == _selectedPage,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("年度计划", textAlign: TextAlign.center),
              onTap: () {
                _onTapListener(context, "AnnualPlan",
                    <String, dynamic>{'key': widget.myKey}, "年度计划");
              },
              selected: 2 == _selectedPage,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
                title: new Text("同步", textAlign: TextAlign.center),
                onTap: () {
                  _onTapListener(context, "synchronize",
                      <String, dynamic>{'key': widget.myKey}, "同步");
                },
                selected: 4 == _selectedPage),
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
