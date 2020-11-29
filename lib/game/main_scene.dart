import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Zi {
  Zi(this.local) {
    shape = Shape(this);
    speed = Random().nextInt(500) / 1000.0;
  }

  Offset local; // 当前位置
  double angle = 0; // 当前方向
  double speed = 0.05; // 当前速度
  Offset offset = Offset(0, 0); // 移动
  Shape shape; // 外观

  mayTurn() {
    if (1 == Random().nextInt(100)) {
      angle = Random().nextInt(180) / 180.0;
    }
  }

  move() {
    offset = Offset(offset.dx, offset.dy + speed);
  }
}

class Shape {
  Shape(this.zi);

  Zi zi;
  int w = 7;
  int h = 60;

  Paint paint = Paint();

  draw(Canvas canvas, Size size) {
    final l = zi.local.dx * size.width;
    final t = zi.local.dy * size.height;
    final r = l + w;
    final b = t + h;
    var ox = zi.offset.dx;
    var oy = zi.offset.dy;
    if (size.height <= b + oy) {
      oy = size.height - b;
    }
    canvas.save();
    canvas.rotate(0);
    canvas.translate(ox, oy);
    canvas.drawRRect(RRect.fromLTRBXY(l, t, r, b, 4, 4), paint);
    canvas.restore();
  }
}

generator(ValueNotifier<List<Zi>> notifier) {
  int count = 30;
  for (int i = 0; i < count; i++) {
    final lw = Random().nextInt(1000);
    final lh = Random().nextInt(1000);
    final local = Offset(lw / 1000.0, lh / 1000.0);
    Zi zi = Zi(local);

    notifier.value.add(zi);
    print("$i, $lw, $lh, $local");
  }
}

class MainScene extends CustomPainter {
  ValueNotifier<List<Zi>> notifier;

  MainScene(this.notifier) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var zis = notifier.value;
    for (int i = 0; i < zis.length; i++) {
      zis[i].move();
      zis[i].shape.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
