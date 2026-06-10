import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/bookings/models/booking.dart';

part 'my_bookings_event.dart';
part 'my_bookings_state.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  MyBookingsBloc(this._apiClient) : super(MyBookingsInitial()) {
    on<LoadMyBookings>(_onLoadMyBookings);
    on<CancelMyBooking>(_onCancelMyBooking);
  }

  final ApiClient _apiClient;

  Future<void> _onLoadMyBookings(
    LoadMyBookings event,
    Emitter<MyBookingsState> emit,
  ) async {
    final userId = ApiClient.currentUserId;
    if (userId == null) {
      emit(MyBookingsLoaded([]));
      return;
    }
    emit(MyBookingsLoading());
    try {
      final bookings = await _apiClient.getMyBookings(userId);
      emit(MyBookingsLoaded(bookings));
    } catch (e) {
      emit(MyBookingsError(e.toString()));
    }
  }

  Future<void> _onCancelMyBooking(
    CancelMyBooking event,
    Emitter<MyBookingsState> emit,
  ) async {
    try {
      await _apiClient.cancelBooking(event.bookingId);
      add(LoadMyBookings());
    } catch (e) {
      emit(MyBookingsError(e.toString()));
    }
  }
}
