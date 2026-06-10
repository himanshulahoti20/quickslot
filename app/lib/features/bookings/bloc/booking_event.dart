part of 'booking_bloc.dart';

sealed class BookingEvent {}

final class BookSlot extends BookingEvent {
  BookSlot({required this.slotId, required this.date});
  final int slotId;
  final String date;
}

final class ResetBooking extends BookingEvent {}
