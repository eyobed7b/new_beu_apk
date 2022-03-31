import 'package:flutter/material.dart';

MediaQueryData _mediaQueryData;
double screenWidth;
double screenHeight;

void init(BuildContext context) {
  _mediaQueryData = MediaQuery.of(context);
  screenWidth = _mediaQueryData.size.width;
  screenHeight = _mediaQueryData.size.height;
}

extension SizerExt on num {
  double get h => this * screenHeight / 100;

  double get w => this * screenWidth / 100;
}
