import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:visitbih_mobile/all_places.dart';
import "main.dart";
import "all_places.dart";

String region = "";
String previousRegion = "";

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({Key? key}) : super(key: key);

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final notifier = ValueNotifier(Offset.zero);

  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            label: "Info",
            icon: Icon(Icons.info),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App()));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InteractiveMap()));
            }
          });
        },
      ),
      body: Listener(
        onPointerUp: (_) => {
          if (region == previousRegion)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllPlaces(reg: region)))
            }
        },
        onPointerDown: (e) => notifier.value = e.localPosition,
        onPointerMove: (e) => notifier.value = e.localPosition,
        child: CustomPaint(
          painter: InteractiveMapPainter(notifier),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

class Shape {
  Shape(strPath, this._label, this._color) : _path = parseSvgPathData(strPath);

  /// transforms a [_path] into [_transformedPath] using given [matrix]
  void transform(Matrix4 matrix) =>
      _transformedPath = _path.transform(matrix.storage);

  final Path _path;
  Path? _transformedPath;
  final String? _label;
  final Color? _color;
}

class InteractiveMapPainter extends CustomPainter {
  InteractiveMapPainter(this._notifier) : super(repaint: _notifier);

  static final _data =
      '''m 393 438.6l1.6 4.8 4.4 8 4.7 5.2 1.7 3.8 0.3 4.7 3.1 5.6 0.7 1.4 2.3 2.8 1.4 7.6 2.7 2.8 4.4 5.2 4.4 4.2 6.4 0.4 7.1 0.5 7.1 11.3 1.4 5.5 0.1 0 0.2 1.1 1.4 5.1-7.5-2.8-4.7-2.8-6.4 0.5-2.4 5.6-0.7 9.4 0 11.7 2.7 5.2 0 7.9 6.5 0 7.1 1.9 4 7 7.8 9.8 3.4 6.1 3 2.9 3.8 3.7 0 2 0 3.6-1 7.5-3.8 4.7-3.4 6.5-5.7 1.9-8.8 1.9-7.1 0-5.8 0.9-8.4 4.7-6.1 3.7-9.2 4.2-6.7 0-3.1-3.2-1.7-4.3-6.1-1.8-4 3.2-11.5 3.3-13.2 0-2.6 1-11.5 5.5-8.2-7.3-12.4-14.5-40.4-41.6-28.5-22.7-3.6-5.9-2.2-7.5-0.9-6-2-5.1-10.5-9.9-8.3-11.6-12.6-12.9-10-14.9-4-4.7-4.5-3.5-11.2-4.1-2.1-4.2-1.1-5.2-3.3-5.5-2.6-1-6.7 0.5-2.7-0.3-2.5-1.4-2.9-2.3-4.9-4.9-3.8-6.3-5.6-13.9-3.7-6.5-11.1-12-4.2-6.2-4.8-15.3-2.4-11.2-0.3-5.4 0.8-3.9 2.6-5.8 0.9-3 0.6-6 0-0.2 1.5-0.8 2.8-1.3 6.5 1 3-1.5 1.7-3.3 3.7-5.2 6.1-0.5 9.2 0.5 5.7-1.9 8.8-0.9 8.5-3.3 12.5-2.9 4.1-5.2 5.7-10.9 2-1.3 7.9 6.7 7.3 7.2 11 9.2 15.7 10.7 6.9 5.7 6.3 0 4 1 2.9 4.6 3.3 6.6 4.8 8.7 9.1 3.1 4.8 0.5 5.8 5.6 10.3 7.7 13.1 7.1 12.1 7.2 7.7 3.1 4 7.6 5.9 4.1 5.8 1.5 1.5 9.2 0.3 11.2 3.7 4.6 7 1.5 23.7 4.1 0.1-0.2 z
  m 162.1 96.9l2.3 3.8-0.1 2.9-1.5 3.6-5.8 2.6-12.1 4.1-4 6.8 0 6.2 2.5 5.7 7.3 8.7 8.1 2.6 16.8 1.6 17.9 1 8.1 1 15 1.1 13.9 2 9.5 2.1 13.6 3.6 10.6 6.7 11.3 11.4 9.9 13.9 2.5 9.3 0 20.5 1.5 4.2 6.6-0.5 2.2 4.1 1.1 14.9 0 18-0.4 20.5-2.6 6.2-4.7 13.3-11 0.5-14.3 1-14.6-5.6-17.9-6.7-15.4-4.6-9.9 0-5.1 0.5-1.1 7.2 2.2 6.2 3.5 3-2 1.3-5.7 10.9-4.1 5.2-12.5 2.9-8.5 3.3-8.8 0.9-5.7 1.9-9.2-0.5-6.1 0.5-3.7 5.2-1.7 3.3-3 1.5-6.5-1-2.8 1.3-1.5 0.8-0.7-3.3-2.8-2.8-5.3-3.4-4.6-1.2-2.9-0.1-0.9 1.1 0.1-2.8 1.7-1.5 2.2-1.4 1.5-2.6-0.1-5.5-1.7-6.8-6.3-17.6-1.3-7.1-1.7-6.3-3-3.9-5.4-0.9-9.3 4.2-5.3-0.7-5.2-5.7 2-5.7 4.2-5.5 1.1-4.7 2.1-1.1 0.4-0.3-0.9-4.9-1.3-4.4-2-3.4-3.1-1.5-6.2-0.9-3.2-1.1-2.6-1.7-3.4-5.1-2-8.9-2.7-3.9-1.9-0.2-2.2 1.2-2.1 0.6-2-2-0.9-3.2-0.6-3.7-1-3.4-1.7-2-3.2-0.2-1.8 2.2-1.4 3.1-1.9 2.3-2.2 0.8-4.6 0.3-2.4 0.8-3.8 0.6-2.2-2.4-1.7-3.6-1.9-3.3-6.1-4.2-1.4-1.8-6.4-10.8-2.9-6.2-0.3-6.1 3.7-4.9 5.3-1.7 4.5-2.1 1.2-6.3-2.4-6.9-4.1-6.5-3.5-7.3-0.9-9 2-6.4 6.4-11.1 0.9-6.4-3-11 0.1-6.7 6-15.6 1.1-5.7-0.9-21.5 0.2-2.8 2.9-7.9 8.3-7.7 13.8-2.3 24.5 0.7 5.9-1.1 2.8 0.1 3 1.5 2.3 3.3-0.2 3.2-0.9 2.6-0.2 1.7 2.3 1.7 5.6 1.2 3.2 2.4 3.9 6.6 5.4 14.1 4.5 6 23.4 23.4 7.2 4.5 9.7 4.3 9.5 2.1 6.2-1.7 1.4-5.1 z
  m 516.7 328.9l2.3 5.3 2.8 8.2 4.9 5.2 5.3 6.5 0.9 6.5-1.2 15.1 0.6 18.6 3.1 8.6 8.6 8.2 6.5 6.4 7.4-1.2 4.4 0.8 0 5.2 2.1 8.2 1.6 5.6 4.9 3 7.1 0 3.1 3.4 1.3 7.8 1.8 10.7 4.1 0 7.4-0.4 2.2 2.1 0.6 5.2-0.6 3.5 2.7 3.8 0 3.5 5.3 0 2.2 2.5 6.1 10.4 2.2 5.1 3.1 0 3-0.7 2.3 2.4 2.1 11.2 0.3 6-1.2 3.4-3.4 3.4-5.6 2.2-8 6-8.1 3-9.9 0.8-3 3.9-1.3 4.3 0.1 0.1-7.2 1.6-9-2.1-7.1-7.8-1.2-3.2-2.8-7-2.5-3.5-7.7-0.8-12.4 0-8 2.1-6.5 5.6-9.9 1.2-8.7-2.9-10.2-6.1-11.7-2.9-6.5 1.2-5.3 1.7-6.5 0.9-7.1-4.3-5.2-3-4.5-1.1 0 0.1-0.1 0-1.4-5.5-7.1-11.3-7.1-0.5-6.4-0.4-4.4-4.2-4.4-5.2-2.7-2.8-1.4-7.6-2.3-2.8-0.7-1.4-3.1-5.6-0.3-4.7-1.7-3.8-4.7-5.2-4.4-8-1.6-4.8 2.5-8.5 2.2-8.1 1.5-10.2-2.6-13.8-13.5-17.3-6.3-9.7-4.4-11.8-4-12.3-1.1-15.8-1.1-21.5 1.8-10.3 6.3-1.5 13.1 0.5 3.3 3.1 7 2.5 14.6 0.8 12.1 0 9.1 0.5 8.1 5.6 6.6 11.3 5.1 4.6 4.4 5.6 9.1 0.6 16.1 0 22.3-4.1 11 0.5 0.5-0.4 z
  m 482.2 789.9l-2.7-3.2-37.1-24.7-4-4.6-2.9-6.8-2.2-7.2-1.6-3.7-2.7-2.5-5.2-3.3-10.4-9.7-9.9-15.2-5.8-17.5 4.9-29.6-4.1-9.1-7.9-5.4-24.8-3.8-14.9-8.4-5.6-5.2 11.5-5.5 2.6-1 13.2 0 11.5-3.3 4-3.2 6.1 1.8 1.7 4.3 3.1 3.2 6.7 0 9.2-4.2 6.1-3.7 8.4-4.7 5.8-0.9 7.1 0 8.8-1.9 5.7-1.9 3.4-6.5 3.8-4.7 1-7.5 0-3.6 4.4-1.1 6 0.5 1.8 2.9 2 3.2 0 9.8 2.4 3.3 1.6 2.8 0 12.6-1.6 1.9-12.2 0-2.4 1.4-0.3 4.7 0 2.3 3.7 1.9 5.4-0.5 3.8 6 4.6 8.4 5.8 3.8 1.4 4.6 2.7 6.1 0.7 0 4 2.8 10.9 1.8 1 6.1 1 6.5 0.3 8 3.1 7.4 3 6.1 0.4 1.1 2.7 7.7 0 7-0.8 0-14.5-0.9-12.5-1.9-5.8-2.3-6.1-0.5-2.7 2.8-0.6 6.1 3.4 10.2 6.4 1.4 7.8 8.8 3.4 10.2-2.7 13.9-6.2 14.9-8.1 11.4 z
  m 586.8 542.7l2.1 3.3 2.5 10.1 0.4 1.8 2 9.1 1.9 4.7 4.3 4.2 9.6 2.2 7.7-1.7 5.9 0.9 8.3 8 0.1 0.1 3.7 9.8 0.3 7.7 2.8 2.1 7.1 2.6 5.6 4.1 0.9 0.6 3.4 0.9 3.7 0.4 1.2-4.7 2.2-5.1 4.9 1.7 5.9 2.5 7.1 0 2.5 0.6-2.1 2.1-1 9.1 1.4 13.6 2.2 11.6 2.6 11.6-1.1 5-8.8 0-25.3-2.4-22.3 1-18.3 0-17.5-1-1.9 7.5 6.3 10.1 1.1 11.6 0.7 22.6 0.7 31.6-2.9 4-4 5.1-5.9 3-4 6-0.7 5.5 0.7 4 5.8 0.6 1.4 0.5 5.2 2 4.1 4-0.8 13.3-2.5 10-4.4 5-2.6 5.5-0.4 16 0.2 0.7 2.4 14.8 4 13 4.5 8 0.4 0.6 7.6 5.3 16.1 14.5 5.8 5.8 7.3 7.2 2.2 4.7 1.1 2.2 13.6 14.5 12.4 11.9 7.3 7.5 7 2 0.3 7.6-1.2 16.3-5.2-7.6-2.8-2.1-6.9 0.4-13.9-4.7-8.5-4.6-44.6-30.2-13.9-8.9-6-5.1-11-12.5-6.2-4.8-9-2.5-2.8-1.8-8-12.6-0.5-4 0.3-8.4-0.7-3.4-3-4-2.3 0.1-2.1 1.7-2 1.2-5.4-1-10.7-4.2-5.7-1.2-5.6 1.4-3.5 3.6-3.2 5-0.1-0.1-24.7-15.2 4.5 0.2 6.9 3.1 4.3 1.2-3.8-3.7-5.7-3.4 13.8-2.9 7.2-5.3-0.9-9.7-0.1-0.1-7.8-18.5-7.8-9.2 8.1-11.4 6.2-14.9 2.7-13.9-3.4-10.2-7.8-8.8-6.4-1.4-3.4-10.2 0.6-6.1 2.7-2.8 6.1 0.5 5.8 2.3 12.5 1.9 14.5 0.9 0.8 0 0-7-2.7-7.7-0.4-1.1-3-6.1-3.1-7.4-0.3-8-1-6.5-1-6.1-10.9-1.8-4-2.8-0.7 0-2.7-6.1-1.4-4.6-5.8-3.8-4.6-8.4-3.8-6-5.4 0.5-3.7-1.9 0-2.3 0.3-4.7 2.4-1.4 12.2 0 1.6-1.9 0-12.6-1.6-2.8-2.4-3.3 0-9.8-2-3.2-1.8-2.9-6-0.5-4.4 1.1 0-2-3.8-3.7-3-2.9-3.4-6.1-7.8-9.8-4-7-7.1-1.9-6.5 0 0-7.9-2.7-5.2 0-11.7 0.7-9.4 2.4-5.6 6.4-0.5 4.7 2.8 7.5 2.8-1.4-5.1-0.2-1.1 0-0.1 4.5 1.1 5.2 3 7.1 4.3 6.5-0.9 5.3-1.7 6.5-1.2 11.7 2.9 10.2 6.1 8.7 2.9 9.9-1.2 6.5-5.6 8-2.1 12.4 0 7.7 0.8 2.5 3.5 2.8 7 1.2 3.2 7.1 7.8 9 2.1 7.2-1.6 z
  m 776.3 160.2l3.7 14.9 1.4 14.5 1.9 6.2 7.3 0.5 0.3 6.2-1.8 8.2-6.9 4.6-7.4 4.7-2.9 4.1-0.3 8.2 2.5 7.2 9.9 9.8 13.9 16.4 4 3.6 5.1 0 5.9-3.1 7.3-12.8 4.8-11.3 3.3-5.7 9.1-2 9.1 2 1.9 5.7 0.3 17.9 0 3.1-0.7 24.7-2.2 5.1-6.6 5.6-4.4 1.8-7.3 6.2-6.6 4.1-10.2 0.5-11.3 3.1-3.3 8.7-4.8 6.6-7.7 4.6-5.8 1.1-2.2 6.1 1.8 14.8 4 9.2 3.7 9.8 2.6 11.2-1.5 12.2-5.5 10.7-0.5 0.6-6.1-8.6-14.2 0-17.6 0.8-5.3-2.1-2.4-7.4-7.2 0-5.5-1.3-1.3-1.7 0-10.3-3.7-12.6-2.1-12.5-5-4.3-8.7-4.4-6.1-1.3-6.5-7.3-3.1-7.4 0-6.5-1.9-6.9-3.7-2.6-12.7 0.4-4-3-2.5-7.4 0-14.7-0.3-8.7-2.1-6 0-5.2 0.3-7 0-4.6 11.7 0.5 13.2-3 1.5-8.3-1.5-9.2-7-8.2-11.3-3.6-10.6-3.6-12.8-4.7-10.6-4.6-11.4-4.6-10.6-5.7-4-4.6 0-10.4 1.8-6.1 10.3-1.6 11-1 20.1 0 10.2-2.6 6.2-9.8 5.5-16 3.7-9.3 6.6-4.6 6.2-2.6 16.1 0.8 8.8 2.5 0 12.4 2.9 3.6 6.9 0.6 6.3-1.6 9.1-4.1 14.3 1 15.3 4.1 9.9 7.3 z
  m 658.5 257.2l0 4.6-0.3 7 0 5.2 2.1 6 0.3 8.7 0 14.7 2.5 7.4 4 3 12.7-0.4 3.7 2.6 1.9 6.9 0 6.5 3.1 7.4 6.5 7.3 6.1 1.3 8.7 4.4 5 4.3 2.1 12.5 3.7 12.6 0 10.3 1.3 1.7 5.5 1.3 7.2 0 2.4 7.4 5.3 2.1 17.6-0.8 14.2 0 6.1 8.6-3.5 3.5-3.3 6.6-8.4 7.7-11.4 11.7-9.1 5.6-9.4 0.4-1.5-2.8-6.2-1.3-4.3-3-2.5-4.7-4-6-4-3.5-5.3-0.9-9.5 0-1 1.3-2.8 3.5-3.4 6.4-4.3 3.5-11.4 0-3.1 2.6-0.3 5.1 0.3 11.7-3.1 3.8-7.1 3.9-10.2 0.4-8.7-0.4-7.7 2.6-1.9 6.9 0 9.4-2.2 3.5-3.7 1.7-2.7 0-3.1 3 0.6 3.4 0.5 0.6-3 0.7-3.1 0-2.2-5.1-6.1-10.4-2.2-2.5-5.3 0 0-3.5-2.7-3.8 0.6-3.5-0.6-5.2-2.2-2.1-7.4 0.4-4.1 0-1.8-10.7-1.3-7.8-3.1-3.4-7.1 0-4.9-3-1.6-5.6-2.1-8.2 0-5.2-4.4-0.8-7.4 1.2-6.5-6.4-8.6-8.2-3.1-8.6-0.6-18.6 1.2-15.1-0.9-6.5-5.3-6.5-4.9-5.2-2.8-8.2-2.3-5.3 8.3-6.3 12.8-7.2 10.6-6.1 9.2-7.2 6.2-7.1 1.1-8.8 0-8.7-1.5-9.7-6.2-6.2-8.8-8.7-5.5-10.3 0-8.2 4.4-10.3 9.2-18.8 8.7-2.6 13.2 1 10.6 1.6 8.8 8.2 8.4 14.4 8.8 19.1 5.1 8.7 7 1 11.7 0.5 19.7 0 z
  m 735.1 445.3l-2.7 0.1-1.8 7.4-7.7 6.6-7.7 6.1-2.5 5.1-0.4 8.6 1.5 12.7 0.7 10.7 0 11.2-2.2 4.5-4 3.6-7.7 1-7-1.5-10.6-1-3.3 2 0.8 7.1 0.7 8.1 6.9 12.2 3.3 6 7 0.6 11 0.5 8 4 10.6 4.6 12.7 9.5-3.8 4.2-2.1 5.1-0.8 4.3 0.1 3-8.6-3.9-8.5-4-6.2-6.1-7.3-5-12.8 0-2.9 8.6-1.1 14.6-1.8 10.9-2 1.9-2.5-0.6-7.1 0-5.9-2.5-4.9-1.7-2.2 5.1-1.2 4.7-3.7-0.4-3.4-0.9-0.9-0.6-5.6-4.1-7.1-2.6-2.8-2.1-0.3-7.7-3.7-9.8-0.1-0.1-8.3-8-5.9-0.9-7.7 1.7-9.6-2.2-4.3-4.2-1.9-4.7-2-9.1-0.4-1.8-2.5-10.1-2.1-3.3-0.1-0.1 1.3-4.3 3-3.9 9.9-0.8 8.1-3 8-6 5.6-2.2 3.4-3.4 1.2-3.4-0.3-6-2.1-11.2-2.3-2.4-0.5-0.6-0.6-3.4 3.1-3 2.7 0 3.7-1.7 2.2-3.5 0-9.4 1.9-6.9 7.7-2.6 8.7 0.4 10.2-0.4 7.1-3.9 3.1-3.8-0.3-11.7 0.3-5.1 3.1-2.6 11.4 0 4.3-3.5 3.4-6.4 2.8-3.5 1-1.3 9.5 0 5.3 0.9 4 3.5 4 6 2.5 4.7 4.3 3 6.2 1.3 1.5 2.8 z
  m 827.9 554.3l5.8 6.1 5.9 0 8.4 2.5 4.4 5.6 2.9 10.1-1.4 5.1-8.1 1.5-6.2 6.6-8.4 6.6-11.4 5-8.4 4-10.2 1.6-13.5 2-8.1 2-17.2-2.5-11.3-5.6-16.5-13.1-0.5-0.2-0.1-3 0.8-4.3 2.1-5.1 3.8-4.2 0.9 0.6 6.2 1 9.5 0.5 4.7-4.5 4.4-8.6 2.6-11.7 5.1-6.6 11.4-1.5 24.1 0.5 12.1 2 6.2 7.6 z
  m 800.4 148.9l-0.5 1.2-1.3 4.7-7.5 6.6-6.3 0 0-3.9 0.8-7.2-1.1-5-2.8-2.2-6.7-0.5-5.1-1.1-0.8-7.8-6.6-6.7-11-6.1-11 0-10.3-3.9-10.2-7.7-7.8-9.5-3.6-3.9-0.7-11.7 0.3-4.2 2.3 1.5 6.7 2.5 6.2 0.2-0.5-5.1-1.2-4.4 0.1-3.3 3.8-1.5 2 0.1 4.2 1 2 0.1 1.7-0.7 3.6-2.2 1.7-0.3 1.9 0.9 1.2 1.7 1.7 4.7 1.5 2.9 1.7 2.4 2.1 1 2.4-1.3 0.8-1.8 0.5-2.2 0.8-2.1 1.3-1.4 1.7-0.2 1.6 1 1.2 1.6 9.6 19.6 3 3.7 3 1.3 7.2 0.7 1.7 0.7 1.1 1 0.7 1.5 0.7 2.2 0.2 0.8 0 1.9 0.1 1.1 0.6 1 1.3 1.8 0.4 1.2-0.8 3.6-5.5 4.2-1.9 3.6 2.8 10.3 8.8 9.5 6.2 4.1z m-99.8-75.5l-2.2 4.7-1.5 8.4-6.3 3.3-8.7 3.3-7 2.8-2 5-2 4.5-1.1 3.3-13.8 0-5.5-1.1-6.3-11.1-5.5-6.1-4.7-3.9-4.7-0.6-3.2-5-3.9-10-0.4-2.1 2.5 0.1 5.5-1.2 4.5-2.8 1.7-3.8 0.2-4.6 0.6-4.5 2.8-3.5 6.3-1.4 6.1 2.5 11.6 8.4 3.9 1.7 18 1.5 4.9 2.3 4.4 3.7 5.8 6.2 z
  m 621.8 68.8l0.4 2.1 3.9 10 3.2 5 4.7 0.6 4.7 3.9 5.5 6.1 6.3 11.1 5.5 1.1 13.8 0 1.1-3.3 2-4.5 2-5 7-2.8 8.7-3.3 6.3-3.3 1.5-8.4 2.2-4.7 3.6 4 4 2.6-0.3 4.2 0.7 11.7 3.6 3.9 7.8 9.5 10.2 7.7 10.3 3.9 11 0 11 6.1 6.6 6.7 0.8 7.8 5.1 1.1 6.7 0.5-5.4 17.1-9.9-7.3-15.3-4.1-14.3-1-9.1 4.1-6.3 1.6-6.9-0.6-2.9-3.6 0-12.4-8.8-2.5-16.1-0.8-6.2 2.6-6.6 4.6-3.7 9.3-5.5 16-6.2 9.8-10.2 2.6-20.1 0-11 1-10.3 1.6-1.8 6.1 0 10.4 4 4.6 10.6 5.7 11.4 4.6 10.6 4.6 12.8 4.7 10.6 3.6 11.3 3.6 7 8.2 1.5 9.2-1.5 8.3-13.2 3-11.7-0.5-19.7 0-11.7-0.5-7-1-5.1-8.7-8.8-19.1-8.4-14.4-8.8-8.2-10.6-1.6-13.2-1-8.7 2.6-18.3 5-9.5-4.9-6.1-12.2-8.3-22.6-0.3-21.3 2.8-12.3 7.6-7.3 0.1-18-5.3-16.2-0.7-17.5 6.6-14 8.1 10.5 4.7 4.3 5.1 2.1 2.6-0.3 7.5-3.2 7-1.4 2.2-1.2 4.2-3.9 15.6-18.8 3.8-2 4-0.1 4.1 2.3 14.1 12.8 5.7 2.6 4.9 1 3.1 0.1 z
  m 525.1 64l-6.6 14 0.7 17.5 5.3 16.2-0.1 18-7.6 7.3-2.8 12.3 0.3 21.3 8.3 22.6 6.1 12.2 9.5 4.9 18.3-5-9.2 18.8-4.4 10.3 0 8.2 5.5 10.3 8.8 8.7 6.2 6.2 1.5 9.7 0 8.7-1.1 8.8-6.2 7.1-9.2 7.2-10.6 6.1-12.8 7.2-8.3 6.3-0.5 0.4-11-0.5-22.3 4.1-16.1 0-9.1-0.6-4.4-5.6-5.1-4.6-6.6-11.3-8.1-5.6-9.1-0.5-12.1 0-14.6-0.8-7-2.5-3.3-3.1-13.1-0.5-6.3 1.5-1.8 10.3 1.1 21.5 1.1 15.8 4 12.3 4.4 11.8 6.3 9.7 13.5 17.3 2.6 13.8-1.5 10.2-2.2 8.1-2.5 8.5-0.1 0.2-23.7-4.1-7-1.5-3.7-4.6-0.3-11.2-1.5-9.2-5.8-1.5-5.9-4.1-4-7.6-7.7-3.1-12.1-7.2-13.1-7.1-10.3-7.7-5.8-5.6-4.8-0.5-9.1-3.1-4.8-8.7-3.3-6.6-2.9-4.6-4-1-6.3 0-6.9-5.7-15.7-10.7-11-9.2-7.3-7.2-7.9-6.7-3.5-3-2.2-6.2 1.1-7.2 5.1-0.5 9.9 0 15.4 4.6 17.9 6.7 14.6 5.6 14.3-1 11-0.5 4.7-13.3 2.6-6.2 0.4-20.5 0-18-1.1-14.9-2.2-4.1-6.6 0.5-1.5-4.2 0-20.5-2.5-9.3-9.9-13.9-11.3-11.4-10.6-6.7-13.6-3.6-9.5-2.1-13.9-2-15-1.1-8.1-1-17.9-1-16.8-1.6-8.1-2.6-7.3-8.7-2.5-5.7 0-6.2 4-6.8 12.1-4.1 5.8-2.6 1.5-3.6 0.1-2.9-2.3-3.8 2.8-10.3 5.2-9.8 1.2-2.9 0.5-4.3-0.5-2.3-0.1-2.1 1.9-3.3 2.4-1.7 6.7-2.1 2.8-2 3.5-5.6 8.3-18.6 12.1-8.3 14.8 0.5 51 15.3 6.5-0.9 3.2-2.8 0.4-2.7-0.2-3.1 1.4-4.4 2.6-2.5 2.9-1.3 2.5-1.7 1.4-4.1 2.1-1.2 2.6-3.1 2.1-3 0.8-1.6 7-6 2.1 2.1 2.1 7.6 0.3 2.9-0.1 3.1 1.4 2 5.3-0.5-0.7-2.6-1-2.4 3.8 1.4 3.1 3.8 2.7 1.9 2.4-4.6 1 2.8 0.4 2.1-0.3 2.2-1.1 3 1.6-1.3 4-2.6 1.6-1.3 5 10.9 10.9 8.3 22.7 10.6 2.7-1.6 12.2-0.9 1.1-1.6 4.9-10.8 9.9 6.6 4.8 2 8.4 5.5 2.4 2 3.5 2 4.7-0.5 8.5-2.7 0.6-1.3 0.6-2.2 1.2-1.4 2 1.3 1.5 2.4 0.3 2-0.8 2.1-1.9 2.2 3.2 1.1 3.1-0.5 6.1-3.2-2.3 7.5-1.4 2.3 1.9-0.6 12.9-1.7 5.6 0.6 2.8-0.4 5.3-3.4 9.4-10 5.5-2.9 8.5 0.5 7.6 4.3 6.9 6.8 6.2 8.1 z
  m 800.4 148.9l4.2 2.8 7.9 2.6 21.8-0.5 0.2 6.9-3.9 2.8-5.8 2.7-3.9 6.2-3.3 9.8-5.9 4.4-12.8 1.1-3.9 2.8-4.4 5.8-7.3-0.5-1.9-6.2-1.4-14.5-3.7-14.9 5.4-17.1 2.8 2.2 1.1 5-0.8 7.2 0 3.9 6.3 0 7.5-6.6 1.3-4.7 0.5-1.2 z
  m 886.7 270.5l-2.9-5.9-5.4-7.3-8.2-5.7-4.1-1.2-6.2 2.3-7.1 5-4.1 2.3-0.3-17.9-1.9-5.7-9.1-2-9.1 2-3.3 5.7-4.8 11.3-7.3 12.8-5.9 3.1-5.1 0-4-3.6-13.9-16.4-9.9-9.8-2.5-7.2 0.3-8.2 2.9-4.1 7.4-4.7 6.9-4.6 1.8-8.2-0.3-6.2 4.4-5.8 3.9-2.8 12.8-1.1 5.9-4.4 3.3-9.8 3.9-6.2 5.8-2.7 3.9-2.8-0.2-6.9 7.7-0.2 2.8-0.9 8.2-2.5 5.2-0.8 4.2-1.5 22.9-16.8 3.2-0.7 1.6 2.1 1 3.1 1.3 1.7 2.5 0 4.5-2 2.6-0.5 11.3 2.5 2.4-0.4 2.1-1 2.3 0 5.1 4.9 2.5 0.9 2.6-0.3 0.7-0.4 0.1-0.3 2.4 2.8 1.5 1.5 1.1 2 0.7 3 0.3 3.7-0.9 1-1.4 0.3-1.1 1.7-9 43.5-2.6 6.6-2.5 3.8-5.1 4.3-2.8 2.9-1.9 3.4-3.7 10.8-12 20.5-1.2 1.2-2.7 1.6-1.3 1.7-0.5 2.4 0.2 5.7-0.5 2.6-1.4 2.8 z
  m 886.7 270.5l-1.7 2.5-2 1.7-9 3-0.7 5.6 4.1 15.9-0.5 9.8-3 5.3-3.6 4.5-2.1 7.5 0.4 6.8 2 7.1 5.7 12.3 4.6 5.6 5.1 2.4 11 2.4 5.3 2.7 2.2 0.7 3.7 0.2 8.2-2 2.9 0.6 4.4 3.6 4.4 6.5 3.2 7.7 0.5 7.2 1.6 4.6 4.8 5 11.2 8.3 2.7 2.8 1.8 1 1.5-0.4 2.9-3 1.5 0 2.2 2.8 0.6 6.4 1.6 2.2 3.9 3.8 6.1 8.9 8.4 4.9 4.1 5.1 2.4 2 0.9-1 1.6-2.2 2.3-0.8 3.2 2.9 1.9 6.7-2.2 5.8-4.3 4.9-10.5 7.9-6.1 2.2-6.3 0.5-14.5-1.4-13.6 0.9-3.8 1.2-3.7 0.2-3.3-2.1-6.6-6.2-6.5-4.6-3.4-1.3-3.7 0.3-5.3 1.7-2.2 2-1.4 3.3 0 2.6 1.3 4.4-0.6 2.6-2.9 2.8 3 1.9-4.1 11-12.5-14.5-12.5-13-31.1-17.3-24.9-15.9-21.8-5.7-22.1-4.4 3.3-6.6 3.5-3.5 0.5-0.6 5.5-10.7 1.5-12.2-2.6-11.2-3.7-9.8-4-9.2-1.8-14.8 2.2-6.1 5.8-1.1 7.7-4.6 4.8-6.6 3.3-8.7 11.3-3.1 10.2-0.5 6.6-4.1 7.3-6.2 4.4-1.8 6.6-5.6 2.2-5.1 0.7-24.7 0-3.1 4.1-2.3 7.1-5 6.2-2.3 4.1 1.2 8.2 5.7 5.4 7.3 2.9 5.9 z
  m 684.9 606.7l1.8-10.9 1.1-14.6 2.9-8.6 12.8 0 7.3 5 6.2 6.1 8.5 4 8.6 3.9-7.7 6.9-10 1.1-11.6 0-10 9.2-9.9-2.1z m143-52.4l-6.2-7.6-12.1-2-24.1-0.5-11.4 1.5-5.1 6.6-2.6 11.7-4.4 8.6-4.7 4.5-9.5-0.5-6.2-1-0.9-0.6-12.7-9.5-10.6-4.6-8-4-11-0.5-7-0.6-3.3-6-6.9-12.2-0.7-8.1-0.8-7.1 3.3-2 10.6 1 7 1.5 7.7-1 4-3.6 2.2-4.5 0-11.2-0.7-10.7-1.5-12.7 0.4-8.6 2.5-5.1 7.7-6.1 7.7-6.6 1.8-7.4 2.7-0.1 9.4-0.4 9.1-5.6 11.4-11.7 8.4-7.7 22.1 4.4 21.8 5.7 24.9 15.9 31.1 17.3 12.5 13 12.5 14.5-2.2 5.7 2.1 18.7-1 12.9 5.2 14.4-5.2 8.6-11.4-1.4-8.3-5.8-18.7-4.3-17.6 5.8-13.3 9 z
  m 754.9 733.7l-8.1-5.4-11.4-7.1-20.8-18.5-14.5 2.8-10.3-7.1-8.3 4.3-7.3-8.6 4.1-15.7-2.2-16.8 8.8 0 1.1-5-2.6-11.6-2.2-11.6-1.4-13.6 1-9.1 2.1-2.1 2-1.9 9.9 2.1 10-9.2 11.6 0 10-1.1 7.7-6.9 0.5 0.2 16.5 13.1 11.3 5.6 17.2 2.5 8.1-2 13.5-2 10.2-1.6 8.4-4 11.4-5 8.4-6.6 6.2-6.6 8.1-1.5 1.4-5.1-2.9-10.1-4.4-5.6-8.4-2.5-5.9 0-5.8-6.1 13.3-9 17.6-5.8 18.7 4.3 8.3 5.8 11.4 1.4 5.2-8.6-5.2-14.4 1-12.9-2.1-18.7 2.2-5.7 4.1-11 8.8 6.8 7.8 10.1 13.7 22.2 26.1 28.4 5.1 11.6 6.2 19.7 0.4 9.4-6.6 6.4-1.1 4.2-0.4 5.1 0.3 4.9 1.2 3.8 1.9 1.7 0.7 1.6-0.6 1.5-2 1.3-9.6-3.9-3.1 0.2-3.2 7.7-2.2 3-2-3.1-2.2-5.9-3.6-6.8-4.3-5.6-4.3-2.6-2.8 0.8-5.9 4.7-3 1.8-3 0.1-6.5-1.1-2.8 0.8-3.6 5.9-2.4 7.9-3 6-5.7 0-12.2-1.9-6.4 0.7-6.8 8.2-5 2-5.5 0.2-4.3-1.6-3.4-4.2-2.7-5.2-3.6-3.6-5.8 0.6-3.8 2.8-6.1 6.8-4.7 2.4-2.4 1.8-1.5 2.9 0.1 2.9 2.5 1.9 3.9 1.1 1.9 1.1 3.4 5.4-0.2 2.3-1.1 2.9 0 1.8 5.6-1.5 1.8 1.4 8.9 11.7 7.6 21.2 7.7 14.7-1.9 1.6-6.7 0.4-2.9 1.6-2 2.6-1.6 3.1-2 3-2.7 2.4-0.9-2.1-5.2-6.7-2.3-4-0.6-2.9 0.2-2.5-0.2-2.5-1.8-2.5-6.8-4.8-6.2-1.8-15.3 1.4-4.7 2.3 0.9 1.4 1.4 3.2 0.9 1.4-6.8 2.2-32.6 24.1-3.9 5.7 z
  m 676.1 661.6l2.2 16.8-4.1 15.7 7.3 8.6 8.3-4.3 10.3 7.1 14.5-2.8 20.8 18.5 11.4 7.1 8.1 5.4 6.2 3.1-11.1 15.5-4.1 8.9-2.2 11.3 0.2 9.1 4.5 26.7-10.4-1.5-15.2 0.2-14.3 3.3-7.7 7.4-4.9 13.7 0.1 6.1 2.6 7 6 12.2 1.5 6.7-1.9 3.4-3.2 2.5-2.5 3.9 0.2 6.1 2.4 8.3 3.5 8.4 8.8 14.5 5.2 5.4 4.4 5.7 2.7 9.6-0.1 10.1-2.9 7.2-5.4 5.3-7.8 4.6 1.8 3.4 0.5 3.2-0.9 2.1-2.7 0.3-2.8-1.8-3-0.3-2.9 1.3-2.6 2.4-4.2-1.5-9.2-1-3.7-2.5-0.2-0.3 1.2-16.3-0.3-7.6-7-2-7.3-7.5-12.4-11.9-13.6-14.5-1.1-2.2-2.2-4.7-7.3-7.2-5.8-5.8-16.1-14.5-7.6-5.3-0.4-0.6-4.5-8-4-13-2.4-14.8-0.2-0.7 0.4-16 2.6-5.5 4.4-5 2.5-10 0.8-13.3-4.1-4-5.2-2-1.4-0.5-5.8-0.6-0.7-4 0.7-5.5 4-6 5.9-3 4-5.1 2.9-4-0.7-31.6-0.7-22.6-1.1-11.6-6.3-10.1 1.9-7.5 17.5 1 18.3 0 22.3-1 25.3 2.4 z'''
          .split('\n');

  final _shapes = [
    Shape(_data[0], 'West Bosnia', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[1], 'Krajina', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[2], 'Central Bosnia', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[3], 'West Herzegovina', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[4], 'Herzegovina-Neretva', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[5], 'Tuzla', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[6], 'Zenica-Doboj', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[7], 'Sarajevo', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[8], 'Podrinje', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[9], 'Posavina', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[10], 'Doboj', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[11], 'Banja Luka', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[12], 'Brčko', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[13], 'Bijeljina', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[14], 'Eastern Bosnia', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[15], 'Romanija', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[16], 'Foča', const Color.fromARGB(50, 0, 0, 0)),
    Shape(_data[17], 'Trebinje', const Color.fromARGB(50, 0, 0, 0)),
  ];

  final ValueNotifier<Offset> _notifier;
  final Paint _paint = Paint();
  Size _size = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, Size(1000, 1000), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (var shape in _shapes) {
        shape.transform(matrix);
      }
      print('new size: $_size');
    }

    canvas
      ..clipRect(Offset.zero & size)
      ..drawColor(Colors.transparent, BlendMode.src);
    var selectedShape;
    for (var shape in _shapes) {
      final path = shape._transformedPath;
      final selected = path!.contains(_notifier.value);
      _paint
        ..color = (selected ? Colors.teal : shape._color)!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);
      selectedShape ??= selected ? shape : null;

      _paint
        ..color = Colors.grey
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    }
    if (selectedShape != null) {
      previousRegion = region;
      region = selectedShape._label;
      _paint
        ..color = Colors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 12)
        ..style = PaintingStyle.fill;
      canvas.drawPath(selectedShape._transformedPath, _paint);
      _paint.maskFilter = null;

      final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        fontSize: 18,
        fontFamily: 'Roboto',
      ))
        ..pushStyle(ui.TextStyle(
          color: Colors.white,
          shadows: kElevationToShadow[1]! + kElevationToShadow[2]!,
        ))
        ..addText(selectedShape._label);
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: size.width));
      canvas.drawParagraph(paragraph, _notifier.value.translate(0, -32));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
