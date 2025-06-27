import 'package:flutter/material.dart';
/*-- Light & Dark Outlined Button Themes */
class IOutlinedButtonTheme {
  IOutlinedButtonTheme._(); //To avoid creating instances
/* Light Theme */
  static  lightOutlinedButtonTheme(){
  return OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
  elevation: 0,
  foregroundColor: Colors.black,
  side: const BorderSide (color: Colors.blue),
  textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
  shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(14)),
  ),
  );
  }
  static  blackOutlinedButtonTheme(){
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.black,
        side: const BorderSide (color: Colors.blue),
        textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}