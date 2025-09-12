import 'package:flutter/material.dart';

class ColorManager {
  static Color appTitleColor = Colors.black;
  static Color errColor = Colors.red.shade300;
  static Color greyColor = Colors.grey;
  static Color lightPrimary = Colors.white;
  static Color lightBlue = const Color(0xFF4db8ff);
}

const String imagePath = 'assets/AppIcons';

class ImageAssets {
  static const String logo = '$imagePath/appLogo.png';
}

class FontWeightManager {
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight semiBold = FontWeight.w600;
}

class FontSize {
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
}

class FontConstants {
  static const String fontInter = 'Inter';
  static const String fontUbuntu = 'Ubuntu';
  static const String fontHelvetica = 'Helvetica Neue';
}

TextStyle _getTextStyle(double fontSize, String fontFamily,
    FontWeight fontWeight, Color color, TextOverflow? overflow) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
    overflow: overflow,
  );
}

TextStyle getText({
  double fontSize = FontSize.s18,
  String fontFamily = FontConstants.fontHelvetica,
  FontWeight fontWeight = FontWeightManager.bold,
  required Color color,
  TextOverflow? overflow,
}) {
  return _getTextStyle(
    fontSize,
    fontFamily,
    fontWeight,
    color,
    overflow,
  );
}