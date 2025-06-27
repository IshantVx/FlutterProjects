import 'package:flutter/material.dart';
class IChipTheme{
  IChipTheme._();
  static ChipThemeData lightChipTheme(){
    return ChipThemeData(
      disabledColor: Colors.grey.withAlpha(100),
      labelStyle: const TextStyle(color: Colors.black),
      selectedColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: Colors.white,
    );
  }
  static ChipThemeData blackChipTheme(){
    return ChipThemeData(
      disabledColor: Colors.grey.withAlpha(100),
      labelStyle: const TextStyle(color: Colors.white),
      selectedColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: Colors.white,
    );
  }
}