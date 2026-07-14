import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  EdgeInsets get viewPadding => MediaQuery.paddingOf(this);

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
      ),
    );
  }
}

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get toTitleCase =>
      split(' ').map((w) => w.capitalize()).join(' ');

  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  bool get isValidPassword => length >= 8;

  bool get isNotEmpty => trim().isNotEmpty;
}

extension DateTimeExt on DateTime {
  String get toDisplayDate => DateFormat('EEE, MMM d, yyyy').format(this);
  String get toDisplayTime => DateFormat('h:mm a').format(this);
  String get toDisplayDateTime =>
      DateFormat('EEE, MMM d, yyyy • h:mm a').format(this);
  String get toApiFormat => toUtc().toIso8601String();
  bool get isUpcoming => isAfter(DateTime.now());
}

extension DoubleExt on double {
  String get toCurrency => '\$${toStringAsFixed(2)}';
  String get toPrice => '\$${toStringAsFixed(0)}';
}

extension ListExt<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
