import 'package:flutter/material.dart';

class BookingConfirmSheet extends StatelessWidget {
  const BookingConfirmSheet({
    super.key,
    required this.venueName,
    required this.startTime,
    required this.date,
    required this.onConfirm,
    required this.onCancel,
  });
  final String venueName;
  final String startTime;
  final String date;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
