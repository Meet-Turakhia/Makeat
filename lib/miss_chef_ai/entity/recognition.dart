import 'dart:math';

import 'package:flutter/material.dart';

const List<String> displayLabels = [
  "Beetroot",
  "Bottle Gourd",
  "Brinjal",
  "Brocolli",
  "Cabbage",
  "Capcicum",
  "Carrot",
  "Cauliflower",
  "Cluster Beans",
  "Cucumber",
  "Fenugreek",
  "Ladyfinger",
  "Onion",
  "Potato",
  "Radish",
  "Ridge Gourd",
  "Spinach",
  "Spiny Gourd",
  "Tomato",
  "Apple",
  "Avocado",
  "Banana",
  "Blueberries",
  "Cherry",
  "Grapes",
  "Guava",
  "Kiwi",
  "Lemon",
  "Lychee",
  "Mango",
  "Orange",
  "Papaya",
  "Pear",
  "Pineapple",
  "Pomegranate",
  "Chikoo",
  "Strawberries",
  "Sugar Apple",
  "Watermelon",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
];

class Recognition {
  Recognition(this._id, this._labelId, this._score, this._location);
  final int _id;
  int get id => _id;
  final int _labelId;
  int get label => _labelId;
  String get displayLabel => displayLabels[_labelId];
  final double _score;
  double get score => _score;
  final Rect _location;
  Rect get location => _location;

  Rect getRenderLocation(Size actualPreviewSize, double pixelRatio) {
    final ratioX = pixelRatio;
    final ratioY = ratioX;

    final transLeft = max(0.1, location.left * ratioX);
    final transTop = max(0.1, location.top * ratioY);
    final transWidth = min(
      location.width * ratioX,
      actualPreviewSize.width,
    );
    final transHeight = min(
      location.height * ratioY,
      actualPreviewSize.height,
    );
    final transformedRect =
        Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);
    return transformedRect;
  }
}
