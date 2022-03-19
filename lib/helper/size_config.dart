import 'package:flutter/cupertino.dart';

class SizeConfig {
  static double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double screenHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
}
