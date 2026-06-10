part of 'my_bookings_bloc.dart';

sealed class MyBookingsEvent {}

final class LoadMyBookings extends MyBookingsEvent {}

final class CancelMyBooking extends MyBookingsEvent {
  CancelMyBooking({required this.bookingId});
  final int bookingId;
}
