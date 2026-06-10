part of 'slots_bloc.dart';

abstract class SlotsState {}

final class SlotsInitial extends SlotsState {}
final class SlotsLoading extends SlotsState {}
final class SlotsLoaded extends SlotsState {
  SlotsLoaded(this.slots);
  final List<dynamic> slots;
}
final class SlotsError extends SlotsState {
  SlotsError(this.message);
  final String message;
}
