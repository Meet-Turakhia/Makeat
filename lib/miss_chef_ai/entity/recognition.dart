import 'dart:math';

import 'package:flutter/material.dart';

const List<String> displayLabels = [
  "Peach",
  "Apple",
  "Cauliflower",
  "Corn",
  "Cucumber",
  "Custard Apple",
  "Jackfruit",
  "Brinjal",
  "Fig Pie",
  "Garlic",
  "Grapes",
  "Chillie",
  "Avocado",
  "Kiwi",
  "Lemon",
  "Mango",
  "Muskmelon",
  "Onion",
  "Orange",
  "Papaya",
  "Peach",
  "Pear",
  "Persimmon",
  "Banana",
  "Pineapple",
  "Plum",
  "Pomegranate",
  "Sweet Potato",
  "Pumpkin",
  "White Raddish",
  "Strawberry",
  "Tomato",
  "Red Raddish",
  "Watermelon",
  "Beetroot",
  "Bottle Gourd",
  "Capcicum",
  "Bitter Gourd",
  "Brocolli",
  "Cabbage",
  "Carrot",
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
