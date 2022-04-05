import 'package:flutter/material.dart';
import 'field_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Home(),
      // home: FlutterLogin(
      //   onLogin: (LoginData) {},
      //   onRecoverPassword: (String) {},
      // ),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム画面です'),
      ),
      body: Container(
        width: double.infinity,
        child: Container(
          child: Column(
            children: [
              _titleArea(),
              _menuArea(context)
            ],
          ),
          ),
        ),
      );
  }
}

// タイトルエリア
Widget _titleArea() {
  return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(    // 1行目
        children: <Widget>[
          Expanded(  // 2.1列目
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(  // 3.1.1行目
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'お腹すいた',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Container(  // 3.1.2行目
                  child: Text(
                    '空腹は力なり',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Icon(  // 2.2列目
            Icons.star,
            color: Colors.red,
          ),
          Text('41'),  // 2.3列目
        ],
      )
  );
}

Widget _menuArea(BuildContext context) {
  return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Row(
        // 1行目
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(
              Icons.call,
              "CALL",
              context
          ), // 2.1
          _buildButtonColumn(
              Icons.near_me,
              "ROUTE",
              context
          ), // 2.2
          _buildButtonColumn(
              Icons.share,
              "SHARE",
              context
          ) // 2.3
        ],
      ));
}

Widget _buildButtonColumn(IconData icon, String label, BuildContext context) {
  final color = Theme.of(context).primaryColor;

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      RaisedButton(
          child: Column(
            children: [
              Icon(icon, color: color),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: color),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FieldMap('Map'))
            );
          }
      ),
    ],
  );
}

