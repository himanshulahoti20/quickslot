import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/features/bookings/bloc/booking_bloc.dart';
import 'package:app/features/bookings/widgets/booking_confirm_sheet.dart';
import 'package:app/features/slots/bloc/slots_bloc.dart';
import 'package:app/features/slots/models/slot.dart';
import 'package:app/features/slots/widgets/slot_grid.dart';
import 'package:app/features/venues/models/venue.dart';
import 'package:app/features/venues/widgets/date_chip_row.dart';

class VenueDetailScreen extends StatelessWidget {
  const VenueDetailScreen({super.key, required this.venue});
  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SlotsBloc(getIt<ApiClient>())),
        BlocProvider(create: (_) => BookingBloc(getIt<ApiClient>())),
      ],
      child: _VenueDetailBody(venue: venue),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _VenueDetailBody extends StatefulWidget {
  const _VenueDetailBody({required this.venue});
  final Venue venue;

  @override
  State<_VenueDetailBody> createState() => _VenueDetailBodyState();
}

class _VenueDetailBodyState extends State<_VenueDetailBody> {
  late DateTime _selectedDate;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadSlots(_selectedDate);
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      context.read<SlotsBloc>().add(RefreshSlots());
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _loadSlots(DateTime date) {
    context.read<SlotsBloc>().add(LoadSlots(
          venueId: widget.venue.id,
          date: DateFormat('yyyy-MM-dd').format(date),
        ));
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _loadSlots(date);
  }

  void _onSlotTap(Slot slot) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<BookingBloc>(),
        child: BookingConfirmSheet(
          venue: widget.venue,
          slot: slot,
          date: _selectedDate,
        ),
      ),
    );
  }

  void _handleBookingState(BuildContext context, BookingState state) {
    if (state is BookingSuccess) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot booked successfully!'),
          backgroundColor: AppColors.available,
        ),
      );
      context.read<SlotsBloc>().add(RefreshSlots());
    } else if (state is BookingConflict) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Someone just booked this slot. Refreshing...'),
          backgroundColor: Colors.redAccent,
        ),
      );
      context.read<SlotsBloc>().add(RefreshSlots());
    } else if (state is BookingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.venue.name)),
      body: BlocListener<BookingBloc, BookingState>(
        listener: _handleBookingState,
        child: Column(
          children: [
            DateChipRow(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            Expanded(
              child: BlocBuilder<SlotsBloc, SlotsState>(
                builder: (context, state) => switch (state) {
                  SlotsInitial() || SlotsLoading() => _ShimmerGrid(),
                  SlotsError() => _SlotsErrorView(
                      onRetry: () => _loadSlots(_selectedDate),
                    ),
                  SlotsLoaded(:final slots) when slots.isEmpty =>
                    const _EmptySlotsView(),
                  SlotsLoaded(:final slots) => SlotGrid(
                      slots: slots,
                      onSlotTap: _onSlotTap,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading shimmer placeholder ───────────────────────────────────────────────

class _ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(16),
      children: List.generate(
        8,
        (_) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _SlotsErrorView extends StatelessWidget {
  const _SlotsErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 12),
          const Text("Couldn't load slots"),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

// ── Empty view ────────────────────────────────────────────────────────────────

class _EmptySlotsView extends StatelessWidget {
  const _EmptySlotsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 48),
          SizedBox(height: 12),
          Text('No slots for this date'),
        ],
      ),
    );
  }
}
