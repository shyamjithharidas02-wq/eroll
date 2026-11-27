import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static dynamic formatDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    return formattedDate;
  }

  static dynamic currentDay(DateTime date) {
    //final currentDay = DateFormat.EEEE().format(date); => Sunday
    final currentDay = DateFormat('EEE').format(date);
    return currentDay;
  }

  static dynamic formatDateMonthYear(DateTime date) {
    final formattedDate = DateFormat.yMMMMd().format(date);
    return formattedDate;
  }

  static dynamic workDuration(DateTime workStartDate) {
    final currentDate = DateTime.now();
    final days = currentDate.difference(workStartDate).inDays;
    return days;
  }

  static dynamic showSnackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// e.g. "Saturday, 21 Nov"
  static String formatLongDay(DateTime date) =>
      DateFormat('EEEE, d MMM').format(date);

  /// e.g. 24475 -> "₹24,475"
  static String formatRupee(num amount) => NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  ).format(amount);

  /// Plain greeting without emoji, e.g. "Good afternoon".
  static String greetingText([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return "Good morning";
    if (hour >= 12 && hour < 17) return "Good afternoon";
    return "Good evening";
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon 🌤️";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening ⛅️";
    } else {
      return "Good Night 😴";
    }
  }
}
