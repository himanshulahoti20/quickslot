part of 'venues_bloc.dart';

sealed class VenuesState {}

final class VenuesInitial extends VenuesState {}
final class VenuesLoading extends VenuesState {}

final class VenuesLoaded extends VenuesState {
  VenuesLoaded(this.venues);
  final List<Venue> venues;
}

final class VenuesError extends VenuesState {
  VenuesError(this.message);
  final String message;
}
