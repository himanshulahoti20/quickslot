import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/exceptions.dart';
import 'package:app/features/venues/bloc/venues_bloc.dart';
import 'package:app/features/venues/models/venue.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('VenuesBloc', () {
    late _MockApiClient mockClient;
    late VenuesBloc venuesBloc;

    const venue1 = Venue(
      id: 1,
      name: 'Green Court',
      sport: 'badminton',
      address: '12 Park Road',
    );
    const venue2 = Venue(
      id: 2,
      name: 'City Turf',
      sport: 'football',
      address: '45 Stadium Lane',
    );

    setUp(() {
      mockClient = _MockApiClient();
      venuesBloc = VenuesBloc(mockClient);
    });

    tearDown(() => venuesBloc.close());

    test('initial state is VenuesInitial', () {
      expect(venuesBloc.state, isA<VenuesInitial>());
    });

    blocTest<VenuesBloc, VenuesState>(
      'emits [VenuesLoading, VenuesLoaded] when LoadVenues succeeds',
      build: () {
        when(() => mockClient.getVenues())
            .thenAnswer((_) async => [venue1, venue2]);
        return VenuesBloc(mockClient);
      },
      act: (bloc) => bloc.add(LoadVenues()),
      expect: () => [
        isA<VenuesLoading>(),
        isA<VenuesLoaded>().having(
          (s) => s.venues,
          'venues',
          equals([venue1, venue2]),
        ),
      ],
    );

    blocTest<VenuesBloc, VenuesState>(
      'emits [VenuesLoading, VenuesError] when LoadVenues throws ApiException',
      build: () {
        when(() => mockClient.getVenues()).thenThrow(
          const ApiException(statusCode: 500, message: 'Server error'),
        );
        return VenuesBloc(mockClient);
      },
      act: (bloc) => bloc.add(LoadVenues()),
      expect: () => [
        isA<VenuesLoading>(),
        isA<VenuesError>(),
      ],
    );
  });
}
