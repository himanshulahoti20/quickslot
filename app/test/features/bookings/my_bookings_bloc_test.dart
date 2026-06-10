import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/exceptions.dart';
import 'package:app/features/bookings/bloc/my_bookings_bloc.dart';
import 'package:app/features/bookings/models/booking.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('MyBookingsBloc', () {
    late _MockApiClient mockClient;
    late MyBookingsBloc myBookingsBloc;

    const booking1 = Booking(
      id: 1,
      slotId: 3,
      userId: 1,
      date: '2025-06-10',
      status: 'active',
      startTime: '09:00',
      endTime: '10:00',
      venueName: 'Green Court',
      sport: 'badminton',
    );
    const booking2 = Booking(
      id: 2,
      slotId: 4,
      userId: 1,
      date: '2025-06-11',
      status: 'cancelled',
      startTime: '10:00',
      endTime: '11:00',
      venueName: 'City Turf',
      sport: 'football',
    );

    setUp(() {
      mockClient = _MockApiClient();
      myBookingsBloc = MyBookingsBloc(mockClient);
      ApiClient.currentUserId = 1;
    });

    tearDown(() {
      myBookingsBloc.close();
      ApiClient.currentUserId = null;
    });

    test('initial state is MyBookingsInitial', () {
      expect(myBookingsBloc.state, isA<MyBookingsInitial>());
    });

    blocTest<MyBookingsBloc, MyBookingsState>(
      'emits [MyBookingsLoading, MyBookingsLoaded] with bookings list',
      build: () {
        when(() => mockClient.getMyBookings(1))
            .thenAnswer((_) async => [booking1, booking2]);
        return MyBookingsBloc(mockClient);
      },
      act: (bloc) => bloc.add(LoadMyBookings()),
      expect: () => [
        isA<MyBookingsLoading>(),
        isA<MyBookingsLoaded>().having(
          (s) => s.bookings,
          'bookings',
          equals([booking1, booking2]),
        ),
      ],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'emits [MyBookingsLoading, MyBookingsLoaded] with empty list when no bookings',
      build: () {
        when(() => mockClient.getMyBookings(1))
            .thenAnswer((_) async => []);
        return MyBookingsBloc(mockClient);
      },
      act: (bloc) => bloc.add(LoadMyBookings()),
      expect: () => [
        isA<MyBookingsLoading>(),
        isA<MyBookingsLoaded>().having(
          (s) => s.bookings,
          'bookings',
          isEmpty,
        ),
      ],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      'emits [MyBookingsLoading, MyBookingsError] on ApiException',
      build: () {
        when(() => mockClient.getMyBookings(any())).thenThrow(
          const ApiException(statusCode: 500, message: 'Server error'),
        );
        return MyBookingsBloc(mockClient);
      },
      act: (bloc) => bloc.add(LoadMyBookings()),
      expect: () => [
        isA<MyBookingsLoading>(),
        isA<MyBookingsError>(),
      ],
    );

    blocTest<MyBookingsBloc, MyBookingsState>(
      're-fetches after CancelMyBooking succeeds',
      build: () {
        when(() => mockClient.cancelBooking(1))
            .thenAnswer((_) async {});
        when(() => mockClient.getMyBookings(1))
            .thenAnswer((_) async => [booking2]);
        return MyBookingsBloc(mockClient);
      },
      act: (bloc) => bloc.add(CancelMyBooking(bookingId: 1)),
      expect: () => [
        isA<MyBookingsLoading>(),
        isA<MyBookingsLoaded>().having(
          (s) => s.bookings,
          'bookings',
          equals([booking2]),
        ),
      ],
      verify: (_) {
        verify(() => mockClient.cancelBooking(1)).called(1);
        verify(() => mockClient.getMyBookings(1)).called(1);
      },
    );
  });
}
