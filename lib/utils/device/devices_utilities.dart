import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class IDeviceUtils {
  IDeviceUtils._(); // Prevent instantiation

  // 🔹 Static platform flags
  static final bool isAndroid = Platform.isAndroid;
  static final bool isIOS = Platform.isIOS;

  // 🔹 Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // 🔹 Set status bar color
  static Future<void> setStatusBarColor(Color color, {Brightness brightness = Brightness.light}) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
      ),
    );
  }

  // 🔹 Set portrait orientation only
  static Future<void> setPortraitOrientationOnly() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // 🔹 Set landscape orientation only
  static Future<void> setLandscapeOrientationOnly() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // 🔹 Check orientation
  static bool isPortraitOrientation(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  // 🔹 Enable fullscreen mode
  static void setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // 🔹 Show status bar
  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  // 🔹 Hide status bar
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  // 🔹 Get screen height
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // 🔹 Get screen width
  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // 🔹 Get pixel ratio
  static double getPixelRatio(BuildContext context) => MediaQuery.of(context).devicePixelRatio;

  // 🔹 Get status bar height
  static double getStatusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;

  // 🔹 Get bottom navigation bar height
  static double getBottomNavigationBarHeight(BuildContext context) => MediaQuery.of(context).padding.bottom;

  // 🔹 Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom > 0;

  // 🔹 Check if running on a physical device
  static Future<bool> isPhysicalDevice() async {
    // Platform class doesn't directly detect physical vs emulator
    // You may use device_info_plus package for better accuracy if needed
    return !(Platform.isAndroid && !Platform.environment.containsKey('ANDROID_STORAGE'));
  }

  // 🔹 Vibrate device
  static Future<void> vibrate({int durationMs = 100}) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: durationMs);
    }
  }

  // 🔹 Set preferred orientation (flexible)
  static Future<void> setPreferredOrientation(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  // 🔹 Check internet connection
  static Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // 🔹 Launch URL
  static Future<void> launchUrlSafe(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
