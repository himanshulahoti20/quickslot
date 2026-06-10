part of 'booking_bloc.dart';

sealed class BookingState {}

final class BookingInitial extends BookingState {}
final class BookingLoading extends BookingState {}

final class BookingSuccess extends BookingState {
  BookingSuccess(this.bookingId);
  final int bookingId;
}

final class BookingConflict extends BookingState {}

final class BookingError extends BookingState {
  BookingError(this.message);
  final String message;
}
