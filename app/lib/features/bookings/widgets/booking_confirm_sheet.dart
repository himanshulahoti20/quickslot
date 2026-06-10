import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app/features/bookings/bloc/booking_bloc.dart';
import 'package:app/features/slots/models/slot.dart';
import 'package:app/features/venues/models/venue.dart';

class BookingConfirmSheet extends StatelessWidget {
  const BookingConfirmSheet({
    super.key,
    required this.venue,
    required this.slot,
    required this.date,
  });
  final Venue venue;
  final Slot slot;
  final DateTime date;

  static IconData _sportIcon(String sport) =>
      sport == 'badminton' ? Icons.sports_tennis : Icons.sports_soccer;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMMM').format(date);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(_sportIcon(venue.sport), size: 22),
              const SizedBox(width: 8),
              Text(
                'Confirm Booking',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const Divider(height: 24),
          _InfoRow(label: 'Venue', value: venue.name),
          const SizedBox(height: 8),
          _InfoRow(label: 'Date', value: formattedDate),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Time',
            value: '${slot.startTime} – ${slot.endTime}',
          ),
          const SizedBox(height: 24),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              final loading = state is BookingLoading;
              return ElevatedButton(
                onPressed: loading
                    ? null
                    : () => context.read<BookingBloc>().add(
                          BookSlot(
                            slotId: slot.id,
                            date: DateFormat('yyyy-MM-dd').format(date),
                          ),
                        ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Book Now'),
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
