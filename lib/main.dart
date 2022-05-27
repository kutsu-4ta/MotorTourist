import 'package:flutter/material.dart';
import 'maps.dart';
import 'machine.dart';

void main() => runApp(MyApp());

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Container(
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // 表示する Widget の一覧
  static List<Widget> _pageList = [
    // GoogleMaps(),
    Maps(),
    Machine(),
    Text('B'), // TODO:未定
  ];

  // タップ時の処理
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.green),
        title: Text("MotorTourist", style: TextStyle(color: Colors.green)),
      ),
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Go',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.two_wheeler),
            label: 'Machine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share), // TODO:未定
            label: 'Share',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// TODO: 3Dモデル
// class MyMachine extends HookWidget {
// }

// NOTE: 動かない
// NOTE:デバッグの参考用に残しています。
// NOTE: Featureは非同期を実行できるクラス
// NOTE: < >で戻り値の型を指定しています。

// Future<LocationData?> _getLocation() async {
//   print('getlocation');
//   // 位置情報サービスが有効かどうかのチェック
//   var serviceEnabled = await _locationService.serviceEnabled();
//   if (!serviceEnabled) {
//     serviceEnabled = await _locationService.requestService();
//     if (!serviceEnabled) {
//       print('service is not enabled');
//       return null;
//     }
//   }
//
//   // 位置情報取得権限チェック
//   var permissionGranted = await _locationService.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     permissionGranted = await _locationService.requestPermission();
//     if (permissionGranted != PermissionStatus.granted) {
//       print('permission is denied');
//       return null;
//     }
//   }
//   return await _locationService.getLocation();
// }
