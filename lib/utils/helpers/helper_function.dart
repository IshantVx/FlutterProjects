import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class THelperFunction {
  THelperFunction._();

  /// 🔹 Convert color string to Color
  static Color? getColor(String value) {
    value = value.toLowerCase();

    if (value == 'green') {
      return Colors.green;
    } else if (value == 'red') {
      return Colors.red;
    } else if (value == 'blue') {
      return Colors.blue;
    } else if (value == 'pink') {
      return Colors.pink;
    } else if (value == 'grey') {
      return Colors.grey;
    } else if (value == 'purple') {
      return Colors.purple;
    } else if (value == 'black') {
      return Colors.black;
    } else if (value == 'white') {
      return Colors.white;
    } else if (value == 'indigo') {
      return Colors.indigo;
    } else {
      return null; // Unknown color
    }
  }


  /// 🔹 Show Snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  /// 🔹 Show AlertDialog
  static void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
        ],
      ),
    );
  }

  /// 🔹 Truncate text with ellipsis
  static String truncateText(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// 🔹 Check dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 🔹 Get full screen size
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// 🔹 Format date to readable string
  static String getFormattedDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// 🔹 Remove duplicates from a list
  static List<T> removeDuplicates<T>(List<T> items) {
    return LinkedHashSet<T>.from(items).toList(); // preserves order
  }

  /// 🔹 Wrap Widget with Padding if true
  static Widget wrapWidget({required Widget child, bool wrap = true, EdgeInsets padding = const EdgeInsets.all(8)}) {
    return wrap ? Padding(padding: padding, child: child) : child;
  }
}
