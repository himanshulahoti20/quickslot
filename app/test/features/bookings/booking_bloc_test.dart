import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/exceptions.dart';
import 'package:app/features/bookings/bloc/booking_bloc.dart';
import 'package:app/features/bookings/models/booking.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('BookingBloc', () {
    late _MockApiClient mockClient;
    late BookingBloc bookingBloc;

    const booking = Booking(
      id: 42,
      slotId: 5,
      userId: 1,
      date: '2025-06-10',
      status: 'active',
      startTime: '09:00',
      endTime: '10:00',
      venueName: 'Green Court',
      sport: 'badminton',
    );

    setUp(() {
      mockClient = _MockApiClient();
      bookingBloc = BookingBloc(mockClient);
    });

    tearDown(() => bookingBloc.close());

    test('initial state is BookingIdle', () {
      expect(bookingBloc.state, isA<BookingIdle>());
    });

    group('BookSlot', () {
      blocTest<BookingBloc, BookingState>(
        'emits [BookingLoading, BookingSuccess] on successful booking',
        build: () {
          when(() => mockClient.createBooking(5, '2025-06-10'))
              .thenAnswer((_) async => booking);
          return BookingBloc(mockClient);
        },
        act: (bloc) => bloc.add(BookSlot(slotId: 5, date: '2025-06-10')),
        expect: () => [
          isA<BookingLoading>(),
          isA<BookingSuccess>().having(
            (s) => s.booking,
            'booking',
            equals(booking),
          ),
        ],
      );

      blocTest<BookingBloc, BookingState>(
        'emits [BookingLoading, BookingConflict] when SlotTakenException is thrown',
        build: () {
          when(() => mockClient.createBooking(any(), any()))
              .thenThrow(const SlotTakenException('Slot taken'));
          return BookingBloc(mockClient);
        },
        act: (bloc) => bloc.add(BookSlot(slotId: 5, date: '2025-06-10')),
        expect: () => [
          isA<BookingLoading>(),
          isA<BookingConflict>(),
        ],
      );

      blocTest<BookingBloc, BookingState>(
        'emits [BookingLoading, BookingError] when ApiException is thrown',
        build: () {
          when(() => mockClient.createBooking(any(), any())).thenThrow(
            const ApiException(statusCode: 500, message: 'Server error'),
          );
          return BookingBloc(mockClient);
        },
        act: (bloc) => bloc.add(BookSlot(slotId: 5, date: '2025-06-10')),
        expect: () => [
          isA<BookingLoading>(),
          isA<BookingError>(),
        ],
      );
    });

    group('ResetBooking', () {
      blocTest<BookingBloc, BookingState>(
        'emits BookingIdle when ResetBooking is added after BookingSuccess',
        build: () => BookingBloc(mockClient),
        seed: () => BookingSuccess(booking),
        act: (bloc) => bloc.add(ResetBooking()),
        expect: () => [isA<BookingIdle>()],
      );
    });
  });
}
