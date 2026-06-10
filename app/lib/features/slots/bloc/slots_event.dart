part of 'slots_bloc.dart';

abstract class SlotsEvent {}

final class LoadSlots extends SlotsEvent {
  LoadSlots({required this.venueId, required this.date});
  final int venueId;
  final String date;
}
