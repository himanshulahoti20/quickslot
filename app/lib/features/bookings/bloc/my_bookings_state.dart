part of 'my_bookings_bloc.dart';

sealed class MyBookingsState {}

final class MyBookingsInitial extends MyBookingsState {}
final class MyBookingsLoading extends MyBookingsState {}

final class MyBookingsLoaded extends MyBookingsState {
  MyBookingsLoaded(this.bookings);
  final List<Booking> bookings;
}

final class MyBookingsError extends MyBookingsState {
  MyBookingsError(this.message);
  final String message;
}
