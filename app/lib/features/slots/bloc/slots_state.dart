part of 'slots_bloc.dart';

sealed class SlotsState {}

final class SlotsInitial extends SlotsState {}
final class SlotsLoading extends SlotsState {}

final class SlotsLoaded extends SlotsState {
  SlotsLoaded(this.slots);
  final List<Slot> slots;
}

final class SlotsError extends SlotsState {
  SlotsError(this.message);
  final String message;
}
