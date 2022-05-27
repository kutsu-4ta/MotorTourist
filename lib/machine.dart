import 'package:flutter/material.dart';

class Machine extends StatefulWidget {
  @override
  _MachineState createState() => _MachineState();
}

class _MachineState extends State<Machine> {
  String machineName = 'スーパーカブ';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      final height = contraint.maxHeight;
      final width = contraint.maxWidth;

      //Stackの追加
      return Stack(children: [
        // 背景
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('Images/Machine/super_cub.png')))),
        Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.15, 0.4],
            colors: [
              Colors.black45,
              Colors.black54,
              Colors.black87,
            ],
          ),
        )),
        // ステータス
        Container(
            margin: const EdgeInsets.only(
              top: 50,
              left: 200,
            ),
            child: Column(children: const [
              Text('スーパーカブ'),
              Text('10000km'),
            ])),
      ]);
    });
  }
}
