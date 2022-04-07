import 'package:flutter/material.dart';
// import 'google_maps.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  // 非同期処理のときはCompleterを渡す
  Completer<GoogleMapController> _controller = Completer();
  Location _locationService = Location();

  // 現在位置
  LocationData? _yourLocation;

  // 現在位置の監視状況
  StreamSubscription? _locationChangedListen;

  @override
  void initState() {
    super.initState();

    _getLocation().then((value) {
      print('aaa');
      print(value);
      setState(() {
        _yourLocation = value;
      });
    });

    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      print(result);
      setState(() {
        _yourLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (_yourLocation == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Google Map ウィジェットを返す
      return Scaffold(
        body: Container(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(34.643208, 134.997586),
              zoom: 17.0,
            ),
          ),
        ),
      );
    }
  }

  Future<LocationData?> _getLocation() async {
    print('getlocation');
    // 位置情報サービスが有効かどうかのチェック
    var serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        print('service is not enabled');
        return null;
      }
    }

    // 位置情報取得権限チェック
    var permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('permission is denied');
        return null;
      }
    }
    return await _locationService.getLocation();
  }
}
