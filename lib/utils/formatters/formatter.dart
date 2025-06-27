import 'package:intl/intl.dart';

class IFormatter {
  IFormatter._(); // Prevent instantiation

  /// 🔹 Format Date to "dd MMM yyyy" (e.g. 24 Jun 2025)
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// 🔹 Format Currency (e.g. $1,000.00)
  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return format.format(amount);
  }

  /// 🔹 Format Phone Number (e.g. 980-000-0000)
  static String formatPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    } else {
      return input;
    }
  }
}
