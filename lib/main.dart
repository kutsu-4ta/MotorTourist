import 'package:flutter/material.dart';
import 'google_maps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Contents(),
      // home: FlutterLogin(
      //   onLogin: (LoginData) {},
      //   onRecoverPassword: (String) {},
      // ),
    );
  }
}

class Contents extends StatelessWidget {
  final items = List<String>.generate(20, (index) => "$index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ホーム画面")),
      body: Container(
        width: double.infinity,

        // HACK:リストビュー
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('${items[index]}'),
            // subtitle: Image.asset('images/hashibirokou.jpg'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoogleMaps()));
            },
          ),
        ),

        // HACK:グリッドビュー
        // child:GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        // crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        //   children: List.generate(100, (index) {
        //     return Column(
        //       children: <Widget>[
        //         Expanded(
        //           child: Image.asset('images/hashibirokou.jpg'),
        //         ),
        //         Text('Item $index',
        //             style: Theme.of(context).textTheme.headline5),
        //       ],
        //     );
        //   }),
        // ),

        // HACK: ライズドボタン
        // child: RaisedButton(
        //   child: Text("編集画面"),
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage()));
        //   },
        // ),
      ),
    );
  }
}
