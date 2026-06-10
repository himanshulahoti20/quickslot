import 'package:flutter/material.dart';

class DateChipRow extends StatelessWidget {
  const DateChipRow({super.key, required this.selectedDate, required this.onDateSelected});
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
