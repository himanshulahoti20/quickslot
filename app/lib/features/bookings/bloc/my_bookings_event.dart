part of 'my_bookings_bloc.dart';

abstract class MyBookingsEvent {}

final class LoadMyBookings extends MyBookingsEvent {
  LoadMyBookings(this.userId);
  final int userId;
}

final class CancelBooking extends MyBookingsEvent {
  CancelBooking({required this.bookingId, required this.userId});
  final int bookingId;
  final int userId;
}
