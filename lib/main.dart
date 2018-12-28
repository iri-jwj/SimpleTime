import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/scenes/syn.dart';
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
      routes: <String, WidgetBuilder>{'syn': (_) => SynchronizePage(null)},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.myKey, this.title}) : super(key: myKey);

  final String title;
  final Key myKey;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      Navigator.of(context).pushNamed("syn");
    });
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
              height: ScreenUtil().setHeight(150),
              child: new Center(
                child: new Text("MenuList", textAlign: TextAlign.center),
              ),
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("todos", textAlign: TextAlign.center),
              onTap: null,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("日程管理", textAlign: TextAlign.center),
              onTap: null,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
              title: new Text("年度计划", textAlign: TextAlign.center),
              onTap: null,
            ),
            new Divider(
              height: 1,
            ),
            new ListTile(
                title: new Text("同步", textAlign: TextAlign.center),
                onTap: () {
                  Navigator.of(context).pop();
                  ProjectRouter().getPage(ProjectRouterOption(
                      "projectFlutter://synchronize",
                      <String, dynamic>{'key': widget.myKey}));
                }),
            new Divider(
              height: 1,
            ),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
