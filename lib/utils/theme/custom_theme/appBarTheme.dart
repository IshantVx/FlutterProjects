import 'package:flutter/material.dart';
class IAppBarTheme{
  IAppBarTheme._();
  static lightAppBarTheme(){
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black,size: 24),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black)
    );
  }
  static darkAppBarTheme(){
    return AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black,size: 24),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 24),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black)
    );
  }
}