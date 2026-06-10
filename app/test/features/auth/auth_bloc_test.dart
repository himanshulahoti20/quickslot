import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() => authBloc = AuthBloc());
    tearDown(() => authBloc.close());

    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });
  });
}
