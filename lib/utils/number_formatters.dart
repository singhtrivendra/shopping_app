import 'package:intl/intl.dart';

class NumberFormatters {
  /// Formats a number as Indian Rupees with comma separators
  static String formatIndianRupees(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN', 
      symbol: '₹', 
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Rounds a number to two decimal places
  static double roundToTwoDecimal(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Calculates discount price
  static double calculateDiscountedPrice(double originalPrice, double discountPercentage) {
    return originalPrice * (1 - discountPercentage / 100);
  }
}
