// lib/constants/colors.dart

import 'package:flutter/widgets.dart';

// Define the colors used in the app
class AppColor {
  AppColor._();
  static const Color hBlue = Color.fromRGBO(13,110,253,1.0);
  static const Color hBlueLight = Color.fromRGBO(229,244,255,1.0);
  static const Color hGrey = Color.fromRGBO(125,132,141,1.0);
  static const Color hGreyLight = Color.fromRGBO(247,247,249,1.0);
  static const Color hGreyDark = Color.fromRGBO(35,38,47,1.0);
  static const Color hWhite = Color.fromRGBO(255,255,255,1.0);
  static const Color hBlack = Color.fromRGBO(0,0,0,1.0);

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
     ],
   );
}