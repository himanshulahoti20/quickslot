part of 'slots_bloc.dart';

sealed class SlotsEvent {}

final class LoadSlots extends SlotsEvent {
  LoadSlots({required this.venueId, required this.date});
  final int venueId;
  final String date;
}

final class RefreshSlots extends SlotsEvent {}
