import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _offsets = <Offset>[];
  bool isUpdate = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final mapPainter = MapPainter(isUpdate);
    final foregroundPainter = ForegroundPainter(_offsets);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _offsets.clear();
            _offsets.add(details.localPosition);
            isUpdate = true;
          });
        },
        onPanUpdate: (details) {
          // setState(() {
          //   _offsets.clear();
          //   _offsets.add(details.localPosition);
          //   isUpdate = false;
          // });
        },
        onPanEnd: (details) {
        },
        child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: mapPainter,
            foregroundPainter: foregroundPainter
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  List map;

  final _wuxing2 = [
    // Colors.yellowAccent,
    Color(0xEEFFFF00),
    // Colors.green,
    Color(0xEE4CAF50),
    // Colors.lightBlue,
    Color(0xEE03A9F4),
    // Colors.deepOrange,
    Color(0xEEFF5722),
    Colors.brown,
    // Color(0xAA795548),
  ];

  final _paint = Paint()
  // ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.butt;

  var widthBlockCount;
  var heightBlockCount;
  var block;

  bool isUpdate;

  MapPainter(this.isUpdate) : super();

  void update() {
    final _count = Random().nextInt(100);
    for (int i = 0; i < _count; i++) {
      final dx = Random().nextInt(widthBlockCount);
      final dw = Random().nextInt(widthBlockCount - dx);
      final dy = Random().nextInt(heightBlockCount);
      final dh = Random().nextInt(heightBlockCount - dy);
      final _xing2 = Random().nextInt(4);
      print("gen $dx, $dw, $dy, $dh");
      for (int m = 0; m < dw; m++) {
        for (int n = 0; n < dh; n++) {
          if (null == map[dx + m][dy + n]) {
            map[dx + m][dy + n] = _wuxing2[_xing2];
          } else {
            map[dx + m][dy + n] = Color.alphaBlend(_wuxing2[_xing2], map[dx + m][dy + n]);
          }
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (null == widthBlockCount) {
      var width = size.width;
      var height = size.height;

      if (height < width) {
        final temp = width;
        width = height;
        height = temp;
      }

      widthBlockCount = 70;
      block = width / widthBlockCount;
      heightBlockCount = height ~/ block;
    }

    if (null == map) {
      map = List.generate(widthBlockCount, (i) => List(heightBlockCount), growable: false);
    }

    if (null != isUpdate &&isUpdate) {
      update();

      for (int i = 0; i < widthBlockCount; i++) {
        for (int j = 0; j < heightBlockCount; j++) {
          if (map[i][j] == null) {
            _paint.color = _wuxing2[4];
          } else {
            print(map[i][j]);
            _paint.color = map[i][j];
          }
          canvas.drawRect(Rect.fromLTWH(i * block, j * block, block, block), _paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

typedef Offset Move();

class ForegroundPainter extends CustomPainter {
  final offsets;

  final painter = Paint()
    ..color = Colors.black
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  ForegroundPainter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    if (null != offsets[0]) {
      canvas.drawCircle(offsets[0], 20, painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
