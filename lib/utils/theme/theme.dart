import 'package:flutter/material.dart';
import 'package:newflutterproject/utils/theme/custom_theme/appBarTheme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/bottomSheetTheme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/checkBoxTheme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/chip_theme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/customElevatedButtonTheme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/outline_button_theme.dart';
import 'package:newflutterproject/utils/theme/custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Optional: Enables Material 3 styling
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    chipTheme: IChipTheme.lightChipTheme(),
    scaffoldBackgroundColor: Colors.white,
    textTheme:ITextTheme.lightGetTextTheme(),
    outlinedButtonTheme: IOutlinedButtonTheme.lightOutlinedButtonTheme(),
    checkboxTheme: ICheckBoxTheme.lightCheckBoxTheme(),
    appBarTheme: IAppBarTheme.lightAppBarTheme(),
    inputDecorationTheme: ITextFormFieldTheme.lightInputDecorationTheme(),
    bottomSheetTheme: IBottomSheetTheme.lightBottomSheetThemeData(),
    elevatedButtonTheme: IElevatedButtonTheme.lightElevatedButtonTheme()
  );
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true, // Optional: Enables Material 3 styling
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      chipTheme: IChipTheme.blackChipTheme(),
      scaffoldBackgroundColor: Colors.black,
      textTheme:ITextTheme.darkGetTextTheme(),
      outlinedButtonTheme: IOutlinedButtonTheme.blackOutlinedButtonTheme(),
      checkboxTheme: ICheckBoxTheme.darkCheckBoxTheme(),
      appBarTheme: IAppBarTheme.darkAppBarTheme(),
      inputDecorationTheme: ITextFormFieldTheme.darkInputDecorationTheme(),
      bottomSheetTheme: IBottomSheetTheme.darkBottomSheetThemeData(),
      elevatedButtonTheme: IElevatedButtonTheme.darkElevatedButtonTheme()
  );

}
