import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FieldMap extends StatefulWidget {
  final title;

  FieldMap(this.title);

  @override
  _FieldMapState createState() => _FieldMapState();
}

class _FieldMapState extends State<FieldMap> {
  Offset posImage = Offset(20, 20);
  Offset pos = Offset(50, 50);

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomRight,
          // 画像
          children: <Widget>[
            Positioned(
              left: posImage.dx,
              top: posImage.dy,
              child: Draggable(
                feedback: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset('images/hashibirokou.jpg'),
                ),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset('images/hashibirokou.jpg'),
                ),
                childWhenDragging: Container(),
                onDraggableCanceled: (view, offset) {
                  setState(() {
                    posImage = offset;
                  });
                },
              ),
            ),
            // 四角
            Positioned(
              left: pos.dx,
              top: pos.dy,
              child: Draggable(
                feedback: Container(
                    width: 100.0, height: 100.0, color: Colors.green[100]),
                child:
                    Container(width: 100.0, height: 100.0, color: Colors.green),
                childWhenDragging: Container(),
                onDraggableCanceled: (view, offset) {
                  setState(() {
                    pos = offset;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
