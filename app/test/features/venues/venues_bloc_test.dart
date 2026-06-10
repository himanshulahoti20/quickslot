import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/venues/bloc/venues_bloc.dart';

void main() {
  group('VenuesBloc', () {
    late VenuesBloc venuesBloc;

    setUp(() => venuesBloc = VenuesBloc());
    tearDown(() => venuesBloc.close());

    test('initial state is VenuesInitial', () {
      expect(venuesBloc.state, isA<VenuesInitial>());
    });
  });
}
