import 'package:flutter/material.dart';

class OrgAuthThemeData {
  final Color primary;
  final Color surface;
  final Color onSurface;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? titleStyle;
  final Widget? logo;
  final InputDecorationTheme? inputDecorationTheme;


  const OrgAuthThemeData({
    this.primary = const Color(0xFF1D4ED8),
    this.surface = Colors.white,
    this.onSurface = Colors.black87,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.titleStyle,
    this.logo,
    this.inputDecorationTheme,
  });
}