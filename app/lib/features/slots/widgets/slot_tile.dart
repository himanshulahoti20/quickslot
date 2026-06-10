import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';

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
    final bgColor = isAvailable
        ? AppColors.available.withValues(alpha: 0.08)
        : Colors.grey.shade200;
    final borderColor = isAvailable
        ? AppColors.available.withValues(alpha: 0.4)
        : Colors.grey.shade300;
    final dotColor = isAvailable ? AppColors.available : AppColors.booked;

    return AbsorbPointer(
      absorbing: !isAvailable,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '$startTime–$endTime',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: isAvailable
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
