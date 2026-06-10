import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/venues/bloc/venues_bloc.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('VenuesBloc', () {
    late VenuesBloc venuesBloc;

    setUp(() => venuesBloc = VenuesBloc(_MockApiClient()));
    tearDown(() => venuesBloc.close());

    test('initial state is VenuesInitial', () {
      expect(venuesBloc.state, isA<VenuesInitial>());
    });
  });
}
