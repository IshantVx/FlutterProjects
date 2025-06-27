import 'package:flutter/material.dart';

class ITextTheme {
  static TextTheme lightGetTextTheme() {
    return TextTheme(
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium:  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 18.6, fontWeight: FontWeight.w600, color: Colors.white),
    titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    titleSmall:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white),
    bodyLarge:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white.withAlpha(127)),
    labelLarge:  TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium:  TextStyle(fontSize: 12.8, fontWeight: FontWeight.normal, color: Colors.white.withAlpha(127)),
         // Text Theme

      // bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
      // bodyMedium: style(fontSize: 16, color: Colors.black),
      // bodySmall: TextStyle(fontSize: 14, color: Colors.black),
      // Add other styles as needed
    );
  }
  static TextTheme darkGetTextTheme(){
    return  TextTheme(
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium:  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 18.6, fontWeight: FontWeight.w600, color: Colors.black),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
      titleMedium:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
      titleSmall:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black),
      bodyLarge:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black),
      bodyMedium:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      bodySmall:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black.withAlpha(127)),
      labelLarge:  TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
      labelMedium:  TextStyle(fontSize: 12.8, fontWeight: FontWeight.normal, color: Colors.black.withAlpha(127)),
    );
  }
}