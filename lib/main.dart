import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/main_scene.dart';

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
  ValueNotifier<List<Zi>> notifier;

  @override
  void initState() {
    super.initState();

    notifier = ValueNotifier(<Zi>[]);
    generator(notifier);
    new Timer.periodic(new Duration(milliseconds: 16), (timer) {
      // print(timer.tick);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final contextSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          CustomPaint(
            size: contextSize,
            painter: MainScene(notifier),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {},
            onPanUpdate: (details) {},
            onPanEnd: (details) {},
            child: Container(
              width: contextSize.width,
              height: contextSize.height,
            ),
          ),
        ],
      ),
    );
  }
}
