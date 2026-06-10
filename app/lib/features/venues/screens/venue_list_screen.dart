import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';
import 'package:app/features/venues/bloc/venues_bloc.dart';
import 'package:app/features/venues/widgets/venue_card.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  late final VenuesBloc _venuesBloc;

  @override
  void initState() {
    super.initState();
    _venuesBloc = VenuesBloc(getIt<ApiClient>())..add(LoadVenues());
  }

  @override
  void dispose() {
    _venuesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName =
        authState is AuthAuthenticated ? authState.user.name : null;

    return BlocProvider.value(
      value: _venuesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QuickSlot'),
          actions: [
            if (userName != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Tooltip(
                  message: 'Switch user',
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(SignOut());
                      context.go('/');
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        userName[0].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: BlocBuilder<VenuesBloc, VenuesState>(
          builder: (context, state) {
            return switch (state) {
              VenuesInitial() || VenuesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              VenuesError(:final message) => _ErrorView(
                  message: message,
                  onRetry: () => context.read<VenuesBloc>().add(LoadVenues()),
                ),
              VenuesLoaded(:final venues) when venues.isEmpty => const Center(
                  child: Text('No venues available'),
                ),
              VenuesLoaded(:final venues) => RefreshIndicator(
                  onRefresh: () {
                    context.read<VenuesBloc>().add(LoadVenues());
                    return context.read<VenuesBloc>().stream.firstWhere(
                          (s) => s is VenuesLoaded || s is VenuesError,
                        );
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: venues.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => VenueCard(
                      venue: venues[i],
                      onTap: () => context.go(
                        '/venues/${venues[i].id}',
                        extra: venues[i],
                      ),
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
