import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/constants/app_users.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';
import 'package:app/features/auth/widgets/user_tile.dart';

class UserSelectScreen extends StatelessWidget {
  const UserSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.venueList);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('QuickSlot')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            const Icon(Icons.sports, size: 72),
            const SizedBox(height: 16),
            Text(
              'Select your profile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kAppUsers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final user = kAppUsers[index];
                  return UserTile(
                    user: user,
                    onTap: () => context.read<AuthBloc>().add(SelectUser(user)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
