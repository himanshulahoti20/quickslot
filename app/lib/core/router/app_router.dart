import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';
import 'package:app/features/auth/screens/user_select_screen.dart';
import 'package:app/features/venues/screens/venue_list_screen.dart';
import 'package:app/features/venues/screens/venue_detail_screen.dart';
import 'package:app/features/venues/models/venue.dart';
import 'package:app/features/bookings/screens/my_bookings_screen.dart';

class RouteNames {
  static const String userSelect  = '/';
  static const String venueList   = '/venues';
  static const String venueDetail = '/venues/:id';
  static const String myBookings  = '/bookings';
}

class AppRouter {
  static GoRouter create(AuthBloc authBloc) {
    final refreshListenable = _GoRouterRefreshStream(authBloc.stream);

    return GoRouter(
      initialLocation: RouteNames.userSelect,
      refreshListenable: refreshListenable,
      redirect: (context, state) {
        final authenticated = authBloc.state is AuthAuthenticated;
        if (authenticated && state.matchedLocation == RouteNames.userSelect) {
          return RouteNames.venueList;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.userSelect,
          builder: (context, state) => const UserSelectScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              _AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.venueList,
                  builder: (context, state) => const VenueListScreen(),
                  routes: [
                    GoRoute(
                      // path is ':id' (relative to parent '/venues')
                      path: ':id',
                      builder: (context, state) =>
                          VenueDetailScreen(venue: state.extra as Venue),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.myBookings,
                  builder: (context, state) => const MyBookingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Shell scaffold with bottom nav ──────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the current tab navigates back to the branch root.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_tennis_outlined),
            selectedIcon: Icon(Icons.sports_tennis),
            label: 'Venues',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'My Bookings',
          ),
        ],
      ),
    );
  }
}

// ── Converts a BLoC stream into a ChangeNotifier for GoRouter.refreshListenable

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
