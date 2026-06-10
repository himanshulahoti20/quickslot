part of 'booking_bloc.dart';

abstract class BookingEvent {}

final class BookSlot extends BookingEvent {
  BookSlot({required this.slotId, required this.date, required this.userId});
  final int slotId;
  final String date;
  final int userId;
}
