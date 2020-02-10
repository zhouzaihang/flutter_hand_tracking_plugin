import 'package:flutter/material.dart';
import 'package:flutter_hand_tracking_plugin/HandGestureRecognition.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';
import 'package:flutter_hand_tracking_plugin/gen/landmark.pb.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HandTrackingViewController _controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hand Tracking Example App'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                child: HandTrackingView(
                  onViewCreated: (HandTrackingViewController c) {
                    setState(() => _controller = c);
                  },
                ),
              ),
              _controller == null
                  ? Text("Please grant camera permissions.")
                  : StreamBuilder<NormalizedLandmarkList>(
                      stream: _controller.landMarksStream,
                      initialData: NormalizedLandmarkList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) =>
                          snapshot.data.landmark != null &&
                                  snapshot.data.landmark.length != 0
                              ? Text(
                                  HandGestureRecognition.handGestureRecognition(
                                          snapshot.data.landmark)
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 45),
                                )
                              : Text("No hand landmarks."))
            ],
          ),
        ),
      ),
    );
  }
}
