import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/slots/models/slot.dart';

part 'slots_event.dart';
part 'slots_state.dart';

class SlotsBloc extends Bloc<SlotsEvent, SlotsState> {
  SlotsBloc(this._apiClient) : super(SlotsInitial()) {
    on<LoadSlots>(_onLoadSlots);
    on<RefreshSlots>(_onRefreshSlots);
  }

  final ApiClient _apiClient;
  int? _lastVenueId;
  String? _lastDate;

  Future<void> _onLoadSlots(LoadSlots event, Emitter<SlotsState> emit) async {
    _lastVenueId = event.venueId;
    _lastDate = event.date;
    emit(SlotsLoading());
    try {
      final slots = await _apiClient.getSlots(event.venueId, event.date);
      emit(SlotsLoaded(slots));
    } catch (e) {
      emit(SlotsError(e.toString()));
    }
  }

  Future<void> _onRefreshSlots(RefreshSlots event, Emitter<SlotsState> emit) async {
    if (_lastVenueId == null || _lastDate == null) return;
    // Keep current grid visible during refresh — no loading state.
    try {
      final slots = await _apiClient.getSlots(_lastVenueId!, _lastDate!);
      emit(SlotsLoaded(slots));
    } catch (e) {
      // Silently ignore refresh errors; user can retry manually.
    }
  }
}
