import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hand_tracking_plugin/HandGestureRecognition.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';
import 'package:flutter_hand_tracking_plugin/gen/landmark.pb.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HandTrackingViewController _controller;
  Gestures _gesture;

  Color _selectedColor = Colors.black;
  Color _pickerColor = Colors.black;
  double _opacity = 1.0;
  double _strokeWidth = 3.0;
  double _canvasHeight = 300;
  double _canvasWeight = 300;

  bool _showBottomList = false;
  List<DrawingPoints> _points = List();
  SelectedMode _selectedMode = SelectedMode.StrokeWidth;

  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  void continueDraw(landmark) => setState(() => _points.add(DrawingPoints(
      points: Offset(landmark.x * _canvasWeight, landmark.y * _canvasHeight),
      paint: Paint()
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..color = _selectedColor.withOpacity(_opacity)
        ..strokeWidth = _strokeWidth)));

  void finishDraw() => setState(() => _points.add(null));

  void _onLandMarkStream(NormalizedLandmarkList landmarkList) {
    if (landmarkList.landmark != null && landmarkList.landmark.length != 0) {
      setState(() => _gesture =
          HandGestureRecognition.handGestureRecognition(landmarkList.landmark));
      if (_gesture == Gestures.ONE)
        continueDraw(landmarkList.landmark[8]);
      else if (_points.length != 0) finishDraw();
    } else
      _gesture = null;
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in _colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('选择颜色'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _pickerColor,
                onColorChanged: (color) => _pickerColor = color,
//                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('保存'),
                onPressed: () {
                  setState(() => _selectedColor = _pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Tracking Example App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: HandTrackingView(
                onViewCreated: (HandTrackingViewController c) => setState(() {
                  _controller = c;
                  if (_controller != null)
                    _controller.landMarksStream.listen(_onLandMarkStream);
                }),
              ),
            ),
            _controller == null
                ? Text(
                    "Please grant camera permissions and reopen the application.")
                : Column(
                    children: <Widget>[
                      Text(_gesture == null
                          ? "No hand landmarks."
                          : _gesture.toString()),
                      CustomPaint(
                        size: Size(_canvasWeight, _canvasHeight),
                        painter: DrawingPainter(
                          pointsList: _points,
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.greenAccent),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.album),
                      onPressed: () => setState(() {
                        if (_selectedMode == SelectedMode.StrokeWidth)
                          _showBottomList = !_showBottomList;
                        _selectedMode = SelectedMode.StrokeWidth;
                      }),
                    ),
                    IconButton(
                      icon: Icon(Icons.opacity),
                      onPressed: () => setState(() {
                        if (_selectedMode == SelectedMode.Opacity)
                          _showBottomList = !_showBottomList;
                        _selectedMode = SelectedMode.Opacity;
                      }),
                    ),
                    IconButton(
                      icon: Icon(Icons.color_lens),
                      onPressed: () => setState(() {
                        if (_selectedMode == SelectedMode.Color)
                          _showBottomList = !_showBottomList;
                        _selectedMode = SelectedMode.Color;
                      }),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _showBottomList = false;
                        _points.clear();
                      }),
                    ),
                  ],
                ),
                Visibility(
                  child: (_selectedMode == SelectedMode.Color)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getColorList(),
                        )
                      : Slider(
                          value: (_selectedMode == SelectedMode.StrokeWidth)
                              ? _strokeWidth
                              : _opacity,
                          max: (_selectedMode == SelectedMode.StrokeWidth)
                              ? 50.0
                              : 1.0,
                          min: 0.0,
                          onChanged: (val) {
                            setState(() {
                              if (_selectedMode == SelectedMode.StrokeWidth)
                                _strokeWidth = val;
                              else
                                _opacity = val;
                            });
                          }),
                  visible: _showBottomList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
