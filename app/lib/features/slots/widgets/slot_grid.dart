import 'package:flutter/material.dart';
import 'package:app/features/slots/models/slot.dart';
import 'package:app/features/slots/widgets/slot_tile.dart';

class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.slots,
    required this.onSlotTap,
  });
  final List<Slot> slots;
  final void Function(Slot) onSlotTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(16),
      children: slots.map((slot) {
        return SlotTile(
          startTime: slot.startTime,
          endTime: slot.endTime,
          isAvailable: slot.isAvailable,
          onTap: slot.isAvailable ? () => onSlotTap(slot) : null,
        );
      }).toList(),
    );
  }
}
