import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/bookings/bloc/booking_bloc.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('BookingBloc', () {
    late BookingBloc bookingBloc;

    setUp(() => bookingBloc = BookingBloc(_MockApiClient()));
    tearDown(() => bookingBloc.close());

    test('initial state is BookingInitial', () {
      expect(bookingBloc.state, isA<BookingInitial>());
    });
  });
}
