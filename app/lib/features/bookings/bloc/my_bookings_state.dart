part of 'my_bookings_bloc.dart';

abstract class MyBookingsState {}

final class MyBookingsInitial extends MyBookingsState {}
final class MyBookingsLoading extends MyBookingsState {}
final class MyBookingsLoaded extends MyBookingsState {
  MyBookingsLoaded(this.bookings);
  final List<dynamic> bookings;
}
final class MyBookingsError extends MyBookingsState {
  MyBookingsError(this.message);
  final String message;
}
