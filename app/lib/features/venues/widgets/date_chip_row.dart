import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/core/constants/app_colors.dart';

class DateChipRow extends StatelessWidget {
  const DateChipRow({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(
      7,
      (i) => DateTime(today.year, today.month, today.day + i),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: dates.map((date) {
          final selected = _isSameDay(date, selectedDate);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(DateFormat('EEE d').format(date)),
              selected: selected,
              onSelected: (_) => onDateSelected(date),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : null,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: selected
                  ? const BorderSide(color: AppColors.primary, width: 2)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
