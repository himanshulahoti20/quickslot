import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/constants/app_users.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() => authBloc = AuthBloc());

    tearDown(() {
      authBloc.close();
      ApiClient.currentUserId = null;
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticated when SelectUser is added',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(SelectUser(user: kAppUsers.first)),
      expect: () => [
        isA<AuthAuthenticated>().having(
          (s) => s.user,
          'user',
          equals(kAppUsers.first),
        ),
      ],
      verify: (_) {
        expect(ApiClient.currentUserId, equals(kAppUsers.first.id));
      },
    );
  });
}
