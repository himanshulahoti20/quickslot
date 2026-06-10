import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/bookings/bloc/booking_bloc.dart';

void main() {
  group('BookingBloc', () {
    late BookingBloc bookingBloc;

    setUp(() => bookingBloc = BookingBloc());
    tearDown(() => bookingBloc.close());

    test('initial state is BookingInitial', () {
      expect(bookingBloc.state, isA<BookingInitial>());
    });
  });
}
