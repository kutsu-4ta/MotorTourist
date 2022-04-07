import 'package:flutter/material.dart';
// import 'google_maps.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    GoogleMaps(),
    Text('A'),
    Text('B'),
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
            icon: Icon(Icons.share),
            label: 'Share',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// class GoogleMaps extends StatefulWidget {
//   @override
//   _GoogleMapsState createState() => _GoogleMapsState();
// }

class GoogleMaps extends HookWidget {
  // 非同期処理のときはCompleterを渡す
  final Completer<GoogleMapController> _controller = Completer();

  // 初期位置を設定
  final Position _initialPosition = Position(
    latitude: 34.643208,
    longitude: 134.997586,
    timestamp: DateTime.now(),
    altitude: 0,
    accuracy: 0,
    heading: 0,
    floor: null,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  Widget build(BuildContext context) {
    // 初期位置マーカー
    final _initialMarkers = {
      _initialPosition.timestamp.toString(): Marker(
        markerId: MarkerId(_initialPosition.timestamp.toString()),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      ),
    };

    final position = useState<Position>(_initialPosition);
    final markers = useState<Map<String, Marker>>(_initialMarkers);

    // 現在地を取得して状態を管理
    Future<void> _setCurrentLocation(ValueNotifier<Position> position,
        ValueNotifier<Map<String, Marker>> markers) async {
      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 移動として検出する閾値で判定
      const decimalPoint = 3;
      // 過去の座標と最新の座標の小数点第三位で切り捨てた値を判定
      if ((position.value.latitude).toStringAsFixed(decimalPoint) !=
              (currentPosition.latitude).toStringAsFixed(decimalPoint) &&
          (position.value.longitude).toStringAsFixed(decimalPoint) !=
              (currentPosition.longitude).toStringAsFixed(decimalPoint)) {
        // 現在地座標にMarkerを立てる
        final marker = Marker(
          markerId: MarkerId(currentPosition.timestamp.toString()),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
        );
        markers.value.clear();
        markers.value[currentPosition.timestamp.toString()] = marker;
        // 現在地座標のstateを更新する
        position.value = currentPosition;
      }
    }

    Future<void> _animateCamera(ValueNotifier<Position> position) async {
      final Completer = await _controller.future;
      await Completer.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.value.latitude, position.value.longitude),
        ),
      );
    }

    _setCurrentLocation(position, markers);
    _animateCamera(position);

    if (position == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Google Map ウィジェットを返す
      return Scaffold(
        body: Container(
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              zoom: 18,
            ),
            onMapCreated: _controller.complete,
            markers: markers.value.values.toSet(),
          ),
        ),
      );
    }
  }
}

// 動かない
// NOTE:デバッグの参考用に残しています。
// Featureは非同期を実行できるクラス
// < >で戻り値の型を指定しています。

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
