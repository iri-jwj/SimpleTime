import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@ARoute(url: 'projectFlutter://synchronize')
class SynchronizePage extends StatefulWidget {
  SynchronizePage(Key key) : super(key: key);

  @override
  SynchronizeState createState() => SynchronizeState();
}

class SynchronizeState extends State<SynchronizePage> {
  static const jumpPlugin = const MethodChannel('com.jwj.project_flutter/jump');

  Future<Null> _jumpToNative() async {
    String result = await jumpPlugin.invokeMethod('connect');
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("同步"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: IconButton(
                icon: Icon(Icons.add),
                tooltip: 'to Add microsoft account',
                onPressed: _jumpToNative,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
