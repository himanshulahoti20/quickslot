import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/venues/models/venue.dart';

part 'venues_event.dart';
part 'venues_state.dart';

class VenuesBloc extends Bloc<VenuesEvent, VenuesState> {
  VenuesBloc(this._apiClient) : super(VenuesInitial()) {
    on<LoadVenues>(_onLoadVenues);
  }

  final ApiClient _apiClient;

  Future<void> _onLoadVenues(LoadVenues event, Emitter<VenuesState> emit) async {
    emit(VenuesLoading());
    try {
      final venues = await _apiClient.getVenues();
      emit(VenuesLoaded(venues));
    } catch (e) {
      emit(VenuesError(e.toString()));
    }
  }
}
