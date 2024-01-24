import 'package:flutter/material.dart';

class CoordinateProvider extends ChangeNotifier {
  double? lat = 0;
  double? lon = 0;

  void updateCoordinates(
    double? lat,
    double? lon,
  ) {
    this.lat = lat;
    this.lon = lon;

    notifyListeners();
  }
}
