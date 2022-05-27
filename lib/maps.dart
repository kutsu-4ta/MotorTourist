import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Maps extends HookWidget {
  // 非同期処理のときはCompleterを渡す
  final Completer<GoogleMapController> _controller = Completer();

  // オススメのコース
  Future<void> _popularPlace() async {
    // final logger = SimpleLogger();
    // logger.setLevel(
    //   Level.INFO,
    //   includeCallerInfo: true,
    // );
    // logger.info('ログ使いたくなったらこれで！');
  }

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

      // 移動として検出する閾値
      const decimalPoint = 3;
      // 小数点第三位で切り捨てた座標値
      if ((position.value.latitude).toStringAsFixed(decimalPoint) !=
              (currentPosition.latitude).toStringAsFixed(decimalPoint) &&
          (position.value.longitude).toStringAsFixed(decimalPoint) !=
              (currentPosition.longitude).toStringAsFixed(decimalPoint)) {
        // TODO:最終的には目的地に立てる
        // 現在地にMarkerを立てる
        final marker = Marker(
          markerId: MarkerId(currentPosition.timestamp.toString()),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
        );
        markers.value.clear();
        markers.value[currentPosition.timestamp.toString()] = marker;
        // 現在座標のstate更新
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
      // 現在座標が取れるまでローディング
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Google Map ウィジェットを返す
      return Scaffold(
        body: Container(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              zoom: 17,
            ),
            onMapCreated: _controller.complete,
            markers: markers.value.values.toSet(),
            myLocationButtonEnabled: true,
          ),
        ),
        // TODO:現在地ボタンと被ってるので上に移動する
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _popularPlace,
          label: Text('人気ルート'),
          icon: Icon(Icons.two_wheeler),
        ),
      );
    }
  }
}
