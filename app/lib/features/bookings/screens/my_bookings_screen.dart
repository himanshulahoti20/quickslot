import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/bookings/bloc/my_bookings_bloc.dart';
import 'package:app/features/bookings/widgets/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyBookingsBloc>().add(LoadMyBookings());
  }

  Future<void> _refresh() async {
    context.read<MyBookingsBloc>().add(LoadMyBookings());
    await context
        .read<MyBookingsBloc>()
        .stream
        .firstWhere((s) => s is MyBookingsLoaded || s is MyBookingsError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: BlocBuilder<MyBookingsBloc, MyBookingsState>(
        builder: (context, state) => switch (state) {
          MyBookingsInitial() || MyBookingsLoading() =>
            const Center(child: CircularProgressIndicator()),
          MyBookingsLoaded(bookings: final bookings) when bookings.isEmpty =>
            const _EmptyState(),
          MyBookingsLoaded(bookings: final bookings) => RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) =>
                    BookingCard(booking: bookings[i]),
              ),
            ),
          MyBookingsError(message: final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MyBookingsBloc>().add(LoadMyBookings()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Book a slot from the Venues tab.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
