import 'package:flutter/widgets.dart';

class AppColor {
  AppColor._();
  static const Color hBlue = Color.fromRGBO(13,110,253,1.0);
  static const Color hGrey = Color.fromRGBO(125,132,141,1.0);
    static const Color hGreyLight = Color.fromRGBO(247,247,249,1.0);

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