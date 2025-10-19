import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'IBMPlexSansArabic';
  
  // Light (300)
  static TextStyle light({
    required double fontSize,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w300,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
  
  // Regular (400)
  static TextStyle regular({
    required double fontSize,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
  
  // Medium (500)
  static TextStyle medium({
    required double fontSize,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
  
  // SemiBold (600)
  static TextStyle semiBold({
    required double fontSize,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
  
  // Bold (700)
  static TextStyle bold({
    required double fontSize,
    Color color = Colors.black,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
}
