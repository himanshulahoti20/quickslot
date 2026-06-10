import 'package:flutter/material.dart';

class SlotTile extends StatelessWidget {
  const SlotTile({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.onTap,
  });
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
