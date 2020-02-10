import 'dart:math';

import 'package:flutter_hand_tracking_plugin/gen/landmark.pb.dart';

enum Gestures {
  FIVE,
  FOUR,
  TREE,
  TWO,
  ONE,
  YEAH,
  ROCK,
  SPIDERMAN,
  FIST,
  OK,
  UNKNOWN
}

class HandGestureRecognition {
  static bool fingerIsOpen(
          double pseudoFixKeyPoint, double point1, double point2) =>
      point1 < pseudoFixKeyPoint && point2 < pseudoFixKeyPoint;

  static bool thumbIsOpen(List landmarks) =>
      fingerIsOpen(landmarks[2].x, landmarks[3].x, landmarks[4].x);

  static bool firstFingerIsOpen(List landmarks) =>
      fingerIsOpen(landmarks[6].y, landmarks[7].y, landmarks[8].y);

  static bool secondFingerIsOpen(List landmarks) =>
      fingerIsOpen(landmarks[10].y, landmarks[11].y, landmarks[12].y);

  static bool thirdFingerIsOpen(List landmarks) =>
      fingerIsOpen(landmarks[14].y, landmarks[15].y, landmarks[16].y);

  static bool fourthFingerIsOpen(List landmarks) =>
      fingerIsOpen(landmarks[18].y, landmarks[19].y, landmarks[20].y);

  static double getEuclideanDistanceAB(
          double aX, double aY, double bX, double bY) =>
      sqrt(pow(aX - bX, 2) + pow(aY - bY, 2));

  static bool isThumbNearFirstFinger(
          NormalizedLandmark point1, NormalizedLandmark point2) =>
      getEuclideanDistanceAB(point1.x, point1.y, point2.x, point2.y) < 0.1;

  static Gestures handGestureRecognition(List landmarks) {
    if (landmarks.length == 0) return Gestures.UNKNOWN;
    // finger states
    bool thumbIsOpen = HandGestureRecognition.thumbIsOpen(landmarks);
    bool firstFingerIsOpen =
        HandGestureRecognition.firstFingerIsOpen(landmarks);
    bool secondFingerIsOpen =
        HandGestureRecognition.secondFingerIsOpen(landmarks);
    bool thirdFingerIsOpen =
        HandGestureRecognition.thirdFingerIsOpen(landmarks);
    bool fourthFingerIsOpen =
        HandGestureRecognition.fourthFingerIsOpen(landmarks);
    if (thumbIsOpen &&
        firstFingerIsOpen &&
        secondFingerIsOpen &&
        thirdFingerIsOpen &&
        fourthFingerIsOpen)
      return Gestures.FIVE;
    else if (!thumbIsOpen &&
        firstFingerIsOpen &&
        secondFingerIsOpen &&
        thirdFingerIsOpen &&
        fourthFingerIsOpen)
      return Gestures.FOUR;
    else if (thumbIsOpen &&
        firstFingerIsOpen &&
        secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        !fourthFingerIsOpen)
      return Gestures.TREE;
    else if (thumbIsOpen &&
        firstFingerIsOpen &&
        !secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        !fourthFingerIsOpen)
      return Gestures.TWO;
    else if (!thumbIsOpen &&
        firstFingerIsOpen &&
        !secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        !fourthFingerIsOpen)
      return Gestures.ONE;
    else if (!thumbIsOpen &&
        firstFingerIsOpen &&
        secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        !fourthFingerIsOpen)
      return Gestures.YEAH;
    else if (!thumbIsOpen &&
        firstFingerIsOpen &&
        !secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        fourthFingerIsOpen)
      return Gestures.ROCK;
    else if (thumbIsOpen &&
        firstFingerIsOpen &&
        !secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        fourthFingerIsOpen)
      return Gestures.SPIDERMAN;
    else if (!thumbIsOpen &&
        !firstFingerIsOpen &&
        !secondFingerIsOpen &&
        !thirdFingerIsOpen &&
        !fourthFingerIsOpen)
      return Gestures.FIST;
    else if (!firstFingerIsOpen &&
        secondFingerIsOpen &&
        thirdFingerIsOpen &&
        fourthFingerIsOpen &&
        isThumbNearFirstFinger(landmarks[4], landmarks[8]))
      return Gestures.OK;
    else
      return Gestures.UNKNOWN;
  }
}
