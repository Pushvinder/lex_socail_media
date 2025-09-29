import 'package:flutter/material.dart';

class CustomDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    Locale? locale,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000, 1, 1),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      locale: locale,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
  }
}
